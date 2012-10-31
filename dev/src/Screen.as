package  
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import com.eclecticdesignstudio.motion.easing.Sine;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.ascollada.core.DaeInstanceController;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.animation.channel.geometry.VertexChannel3D;
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Sphere3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.objects.primitives.PaperPlane;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportBaseLayer;
	
	
	/**
	 * ...
	 * @author Arthur Tofani
	 * @author Alexandre Fornari
	 */
	public class Screen extends BasicView
	{
		private var instances:Vector.<Instance> = new Vector.<Instance>();
		private var _selectedInstance:Instance = null;
		private var amntinstances:int = 10;
		private var sprInstances:DisplayObject3D;
		private var oldInstance:Instance;
		
		
		private var sprfocus:DisplayObject3D = new DisplayObject3D("duente");
		
		
		public function Screen() 
		{
			super(700, 500, false, false, CameraType.FREE);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		      // skybox images  
        [Embed (source="assets/hot_nebula_0.jpg")]  
        private var BitmapFront:Class;  
        [Embed (source="assets/hot_nebula_270.jpg")]  
        private var BitmapRight:Class;  
        [Embed (source="assets/hot_nebula_180.jpg")]  
        private var BitmapBack:Class;  
        [Embed (source="assets/hot_nebula_90.jpg")]  
        private var BitmapLeft:Class;  
        [Embed (source="assets/hot_nebula_bottom.jpg")]  
        private var BitmapDown:Class;  
        [Embed (source="assets/hot_nebula_top.jpg")]  
        private var BitmapUp:Class;  
		public static const SKYSIZE:Number = Number.MAX_VALUE;  
  
		private var skybox:SkyBox;
        public function loadSkyBox(scene:Scene3D):void {  
            skybox = new SkyBox(BitmapFront, BitmapLeft, BitmapBack, BitmapUp, BitmapRight, BitmapDown, SKYSIZE, SkyBox.QUALITY_HIGH);  
            scene.addChild(skybox);  
			
        }  
		

		

		
		public function init(e:Event = null):void {
			
			camera.target = null;
			
			createLayers();
			createScenario();
			loadSkyBox(scene);
			scene.addChild(sprfocus);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, initRotation);
		}
		
		private function createLayers():void {
			sprInstances = new DisplayObject3D();
			scene.addChild(sprInstances);
			
		}
		
		private var trocaVel:Boolean = false;
		
		public function createScenario():void {
			if(sprInstances.numChildren>0){
				for (var j:int = 0; j < instances.length;j++) {
					scene.removeChild(instances.pop());
				}				
			}
			
			for (var i:int = 0; i < amntinstances; i++) {				
				var inst:Instance = new Instance((Math.random() < 0.5 ? true : false), (Math.floor(Math.random() * 2) + 2) * (trocaVel ? 1 : -1));
				instances.push(inst)
				scene.addChild(inst, "inst_" + i.toString);				
				randomizePosition(inst);
				inst.rotationX = (Math.random() < 0.5 ? 1 : -1) * Math.random() * 45;
				//inst.rotationZ = (Math.random() < 0.5 ? 1 : -1) * Math.random() * 45;
				trocaVel = !trocaVel;
				addEventListener(Event.ENTER_FRAME, inst.moveParticle);
			}
		}
		
		private function randomizePosition(inst:Instance):void {
			inst.x = Math.random() * 10000;
			inst.y = Math.random() * 10000;
			inst.z = Math.random() * 10000;
		}
		
		public function getNewInstance():void {
			setAllVisible();
			if(_selectedInstance != null) _selectedInstance.unReady();
			var i:int = Math.random() * amntinstances;
			while (_selectedInstance == instances[i]) {
				i = Math.random() * amntinstances;
			}
			selectedInstance = instances[i];
			//var pt:Sphere = selectedInstance.getCamPoint();
			var pt:Number3D = getCamerapoint(selectedInstance);
			//Actuate.tween(camera, 3.1, { x:pt.sceneX, y:pt.sceneY, z:pt.sceneZ }, true).ease(Linear.easeNone).onComplete(sendComplete);
			Actuate.tween(camera, 3, { x:pt.x, y:pt.y, z:pt.z }, true).ease(Linear.easeNone).onComplete(sendComplete);
			Actuate.tween(sprfocus, 3, {x:selectedInstance.x, y:selectedInstance.y, z:selectedInstance.z}, true).onUpdate(look).ease(Quad.easeInOut);
		}
		
		public function startExercise():void
		{
			var i:int = Math.random() * amntinstances;
			selectedInstance = instances[i];
			sprfocus.x = selectedInstance.x;
			sprfocus.y = selectedInstance.y; 
			sprfocus.z = selectedInstance.z;
			//var pt:Sphere = selectedInstance.getCamPoint();
			var pt:Number3D = getCamerapoint(selectedInstance);
			camera.x = pt.x; 
			camera.y = pt.y; 
			camera.z = pt.z;
			look();
			sendComplete();
		}
		
		private function getCamerapoint(instance:Instance):Number3D
		{
			var instancePos:Number3D = new Number3D(instance.x, instance.y, instance.z);
			var camPoint:Number3D = new Number3D();
			
			var theta:Number = Math.random() * 160;
			var phi:Number = Math.random() * 80;
			
			theta2 = theta;
			phi2 = phi;
			
			camPoint.x = instancePos.x + distance * Math.cos(theta) * Math.sin(phi);
			camPoint.y = instancePos.y + distance * Math.sin(theta) * Math.sin(phi);
			camPoint.z = instancePos.z + distance * Math.cos(phi);
			
			return camPoint;
		}
		
		
		public function sendComplete():void {
			selectedInstance.makeReady();
			selectedInstance.resetRotation();
			dispatchEvent(new Event(Event.COMPLETE));
			setAllInvisible();
		}

		
		public function look():void {
			if (Math.sin(phi2) < 0) upVector = new Number3D(0, 0, -1);
			else upVector = new Number3D(0, 0, 1);
			
			camera.lookAt(sprfocus, upVector);
		}
		
		public function get selectedInstance():Instance 
		{
			return _selectedInstance;
		}
		
		public function set selectedInstance(value:Instance):void 
		{
			_selectedInstance = value;
		}
		

		public function setAllInvisible():void
		{
			return;
			for each (var item:Instance in instances) 
			{
				if (item != selectedInstance) item.visible = false;
			}
		}
		
		public function setAllVisible():void
		{
			for each (var item:Instance in instances) 
			{
				item.visible = true;
			}
		}
		
		//Rotação da câmera:
		public var distance:Number = 800; 
		public var theta2:Number; 
		public var phi2:Number;
		//private var upPoint:Point = new Point();
		private var upVector:Number3D = new Number3D(0, 0, 1);
		private var clickPoint:Point = new Point();
		
		/*private function calcUpPoint():void
		{
			var dX:Number = camera.x - selectedInstance.x;
			var dY:Number = camera.y - selectedInstance.y;
			var dZ:Number = camera.z - selectedInstance.z;
			
			theta2 = (Math.atan2(Math.sqrt(Math.pow(dX, 2) + Math.pow(dY, 2)), dZ)) * 180 / Math.PI;
			phi2 = Math.atan2(dY, dX) * 180 / Math.PI;
		}*/
		
		public var rotationEnabled:Boolean = true;
		private function initRotation(e:MouseEvent):void 
		{
			
			if (!rotationEnabled) return;
			trace(e.target)
			if (e.target is ViewportBaseLayer)
			{
				clickPoint.x = stage.mouseX;
				clickPoint.y = stage.mouseY;
				stage.addEventListener(Event.ENTER_FRAME, rotating);
				stage.addEventListener(MouseEvent.MOUSE_UP, stopRotating);
			}
		}	
		
		private function rotating(e:Event):void 
		{
			var deltaTheta:Number = (stage.mouseX - clickPoint.x) * Math.PI / 180;
			var deltaPhi:Number = (stage.mouseY - clickPoint.y) * Math.PI / 180;
			
			theta2 += deltaTheta;
			phi2 += deltaPhi;
			
			clickPoint = new Point(stage.mouseX, stage.mouseY);
			
			camera.x = selectedInstance.x + distance * Math.cos(theta2) * Math.sin(phi2);
			camera.y = selectedInstance.y + distance * Math.sin(theta2) * Math.sin(phi2);
			camera.z = selectedInstance.z + distance * Math.cos(phi2);
			
			look();
		}
		
		private function stopRotating(e:MouseEvent):void 
		{
			stage.removeEventListener(Event.ENTER_FRAME, rotating);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopRotating);
		}
		
	}

}