
package  
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Sphere3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.render.material.MaterialManager;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.objects.primitives.PaperPlane;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	
		
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Instance extends DisplayObject3D
	{
		private var _particle:Esfera;
		private var _cylinder:Cylinder;
		private var pts:Vector.<Sphere> = new Vector.<Sphere>();
		private var route:int = 0;
		private var _velocity:int = 10;
		private var _sprParticle:DisplayObject3D = new DisplayObject3D();
		private var lines:Lines3D = new Lines3D(new LineMaterial(0xFFFF00, 0.9));
		private var _seta1Pos:int = UP;
		private var _seta1:Arrow;
		private var _seta2:Arrow;
		public var setaAnswer1:Arrow;
		public var setaAnswer2:Arrow;
		private var cargaPos:Boolean;
		
		public function Instance(cargaPos:Boolean, vel:Number) 
		{
			this.cargaPos = cargaPos;
			this.velocity = vel;
			init();
		}
		
		public static const UP:int = 0;
		public static const DOWN:int = 1;
		
		private function init():void  {
			//velocity  = (Math.random() < 0.5 ? 1 : -1) * Math.floor(Math.random() * 10)+4
			//velocity = -5;
			addChild(sprParticle);
			drawAxis();
			drawParticle();
			drawArrows();
			drawCameraPoints();
		}
		
		public function drawAxis():void {
			
			//var eixos:CartesianAxis3D = new CartesianAxis3D();			
			//addChild(eixos);
			//eixos.scale = 10;
			
			for (var i:int = -500; i < 500; i += 58)
			{
				//var line:Line3D = new Line3D(lines, new LineMaterial(0x000000, 1), 2, new Vertex3D(0, 0, -500), new Vertex3D(0, 0, 500));
				var line:Line3D = new Line3D(lines, new LineMaterial(0xefefef, 1), 2, new Vertex3D(0, 0, i), new Vertex3D(0, 0, i + 30));
				var line2:Line3D = new Line3D(lines, new LineMaterial(0xefefef, 1), 2, new Vertex3D(0, 0, i + 30 + 13), new Vertex3D(0, 0, i + 30 + 13 + 2));
				lines.addLine(line);
				lines.addLine(line2);
			}
			addChild(lines);
		}
		
		public function makeReady():void {
			if (displayAnswer) {
				setaAnswer1.scale = 0;
				setaAnswer2.scale = 0;
				displayAnswer = false;
			}
			seta1.scale = 1;
			seta2.scale = 1
		}
		
		public function unReady():void {
			if (displayAnswer) {
				setaAnswer1.scale = 0;
				setaAnswer2.scale = 0;
				displayAnswer = false;
			}
			seta1.scale = 0;
			seta2.scale = 0;
		}
		
		private var displayAnswer:Boolean = false;
		
		public var carga_positiva:Boolean = true;
		public var ans1:Boolean = false;
		public var ans1_oposto:Boolean = true;
		public var ans2:Boolean = false;
		public var ans2_oposto:Boolean = true;
		
		public function getAnswer():Number
		{
			//trace(seta1.rotationX, setaAnswer1.rotationX);
			//trace(seta2.rotationX, setaAnswer2.rotationX);
			var score:Number = 0;
			carga_positiva = cargaPos;
			trace("R1: ", seta1.rotationX, setaAnswer1.rotationX)
			trace("R2: ", seta2.rotationX, setaAnswer2.rotationX)
			
			ans1_oposto = (Math.abs(seta1.rotationX - setaAnswer1.rotationX) == 180)
			ans2_oposto = (Math.abs(seta2.rotationX - setaAnswer2.rotationX)==180)
			
			if (seta1.rotationX == setaAnswer1.rotationX) {
				score += 50;
				ans1 = true;
			}else {
				ans1 = false;
			}
			
			if (seta2.rotationX == setaAnswer2.rotationX) {
				score += 50;
				ans2 = true;
			}else {
				ans2 = false;
			}
			
			return score;
		}
		
		public function showAnswer():void 
		{
			displayAnswer = true;
			Actuate.tween(seta1, 0.5, { scale:0 }, true);
			Actuate.tween(seta2, 0.5, { scale:0 }, true);
			
			Actuate.tween(setaAnswer1, 0.5, { scale:1 }, true).delay(0.3);
			Actuate.tween(setaAnswer2, 0.5, { scale:1 }, true).delay(0.3);
		}
		
		public function hideAnswer():void 
		{
			displayAnswer = false;
			Actuate.tween(setaAnswer1, 0.5, { scale:0 }, true);
			Actuate.tween(setaAnswer2, 0.5, { scale:0 }, true);
			
			Actuate.tween(seta1, 0.5, { scale:1 }, true).delay(0.3);
			Actuate.tween(seta2, 0.5, { scale:1 }, true).delay(0.3);
		}
		
		public function resetRotation():void
		{
			seta1.rotationX = 90;
			seta2.rotationX = -90;
		}
		
		private const ROTACAO_CIMA:int = -180;
		private const ROTACAO_BAIXO:int = 0;
		
		public function drawArrows():void {
			seta1 = new Arrow(); //Momento angular (L)
			addChild(seta1);
			seta1.rotationX = 90;
			
			seta1.scale = 0;
			
			seta2 = new Arrow(0xFF0000); //Momento magnético (mi)
			addChild(seta2);
			seta2.rotationX = -90;
			seta2.scale = 0;
			
			seta1.y -= 5;
			seta2.y += 5;
			
			setaAnswer1 = new Arrow(); //Resposta momento angular
			addChild(setaAnswer1);
			if (velocity > 0) setaAnswer1.rotationX = ROTACAO_CIMA;
			else setaAnswer1.rotationX = ROTACAO_BAIXO;
			setaAnswer1.scale = 0;
			
			setaAnswer2 = new Arrow(0xFF0000); //resposta momento magnético
			addChild(setaAnswer2);
			if (cargaPos) {
				if (velocity > 0) setaAnswer2.rotationX = ROTACAO_CIMA;
				else setaAnswer2.rotationX = ROTACAO_BAIXO;
			}else {
				if (velocity > 0) setaAnswer2.rotationX = ROTACAO_BAIXO;
				else setaAnswer2.rotationX = ROTACAO_CIMA;
			}
			setaAnswer2.scale = 0;
			
			setaAnswer1.y -= 5;
			setaAnswer2.y += 5;

		}
		
		public function drawCameraPoints():void {
			var c:Sphere;
			
			c = new Sphere(new ColorMaterial(0, 0, false), 20, 3, 3);
			addChild(c);
			c.x = 500;	 c.y = -750;	 c.z = 140;
			pts.push(c);
			c.alpha = 0;
			
			c = new Sphere(new ColorMaterial(0, 0, false), 20, 3, 3);
			addChild(c);
			c.x = -500;	 c.y = 750;	 c.z = -140;
			pts.push(c);
			c.alpha = 0;
			
			c = new Sphere(new ColorMaterial(0, 0, false), 20, 3, 3);
			addChild(c);
			c.x = -900;	 c.y = 300;	 c.z = -100;
			pts.push(c);
			c.alpha = 0; 
		}
		
		
		public function definePos_Seta1(value:int):void {		
			seta1.orientation = value;
			var rot:int = 0
			if (value == DOWN) {
				rot = 0;
			} else if (value == UP) {
				rot = 180;
			} 
			Actuate.tween(seta1, 1, {rotationX:rot})
		}
		
		public function definePos_Seta2(value:int):void {		
			seta2.orientation = value;
			var rot:int = 0
			if (value == DOWN) {
				rot = 0;
			} else if (value == UP) {
				rot = -180;
			} 
			Actuate.tween(seta2, 1, { rotationX:rot } );
		}
		
		public function definePos_Seta1new(value:int):void {
			seta1.rotationX = value;
			//Actuate.tween(seta1, 0.5, { rotationX:value } );
		}
		
		public function definePos_Seta2new(value:int):void {
			seta2.rotationX = value;
			//Actuate.tween(seta2, 0.5, { rotationX:value } );
		}
		
		public function drawParticle():void {
			var materialCylinder:ColorMaterial = new ColorMaterial(0x0080C0, 1);
			materialCylinder.doubleSided = true;
			cylinder = new Cylinder(materialCylinder, 300, 4, 30, 1, -1, false, false);
			cylinder.rotationX = 90;
			addChild(cylinder);
			
			var materialCylinder2:ColorMaterial = new ColorMaterial(0x80FFFF, 0.2);
			materialCylinder2.doubleSided = true;
			var cil2:Cylinder = new Cylinder(materialCylinder2, 300, 1, 20, 2, -1, true, true);
			cil2.rotationX = 90;
			addChild(cil2);
			
			particle = new Esfera(cargaPos);
			sprParticle.addChild(particle);
			sprParticle.rotationX = 90;
		}
		
		public function moveParticle(e:Event):void 
		{			
			sprParticle.rotationZ += velocity;
			if (sprParticle.rotationZ >= 36000 || sprParticle.rotationZ <= -36000) sprParticle.rotationZ = 0; 
		}
		
		public function getCamPoint():Sphere {
			var i:int = Math.random() * 10000;
			return pts[i %3]
			//return pts[0];
		}
		
		
		public function get particle():Esfera 
		{
			return _particle;
		}
		
		public function set particle(value:Esfera):void 
		{
			_particle = value;
		}
		
		public function get cylinder():Cylinder 
		{
			return _cylinder;
		}
		
		public function set cylinder(value:Cylinder):void 
		{
			_cylinder = value;
		}
		
		public function get sprParticle():DisplayObject3D 
		{
			return _sprParticle;
		}
		
		public function set sprParticle(value:DisplayObject3D):void 
		{
			_sprParticle = value;
		}
		
		public function get seta1():Arrow 
		{
			return _seta1;
		}
		
		public function set seta1(value:Arrow):void 
		{
			_seta1 = value;
		}
		
		public function get seta1Pos():int 
		{
			return _seta1Pos;
		}
		
		public function get velocity():int 
		{
			return _velocity;
		}
		
		public function set velocity(value:int):void 
		{
			_velocity = value;
		}
		
		public function get seta2():Arrow 
		{
			return _seta2;
		}
		
		public function set seta2(value:Arrow):void 
		{
			_seta2 = value;
		}
		
	}
	
}