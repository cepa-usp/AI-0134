package  
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shaders.FlatShader;
	import org.papervision3d.materials.shaders.GouraudShader;
	import org.papervision3d.materials.shaders.ShadedMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Sphere;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Esfera extends DisplayObject3D
	{
		private var sphere:Sphere;
		private var color:uint;
		private var cargaPositiva:Boolean;
		private var posColor:uint = 0x008000;
		private var negColor:uint = 0x804000;
		private var esfera:DAE;
		
		//Adiciona a figura textura_soma.jpg ao flash acessível pela classe PosImg.
		//[Embed (source = "./models/textura_soma.jpg")]
		//private var PosImg:Class;
		//
		//Adiciona a figura textura_sub.jpg ao flash acessível pela classe NegImg.
		//[Embed (source = "./models/textura_sub.jpg")]
		//private var NegImg:Class;
		
		public function Esfera(cargaPositiva:Boolean)
		{
			this.cargaPositiva = cargaPositiva;
			//createSphere();
			loadModels();
		}
		
		private function createSphere():void 
		{
			var materialSphere:ColorMaterial = new ColorMaterial((cargaPositiva ? posColor : negColor), 1, false);
			sphere = new Sphere(materialSphere, 30, 6, 6);
			addChild(sphere)
			sphere.x = 300;
		}
		
		private function loadModels():void
		{
			//Modelo DAE da esfera.
			esfera = new DAE();
			esfera.addEventListener(FileLoadEvent.LOAD_COMPLETE, esferaLoaded);
			if (cargaPositiva) DAE(esfera).load("models/soma.DAE");
			else DAE(esfera).load("models/subtra.DAE");
		}
		
		private function esferaLoaded(e:Event):void 
		{
			esfera.removeEventListener(FileLoadEvent.LOAD_COMPLETE, esferaLoaded);
			
			//var esferaBmp:BitmapData;
			//
			//if (cargaPositiva) esferaBmp = new PosImg().bitmapData;
			//else esferaBmp = new NegImg().bitmapData;
			//
			//var esferaMaterial:BitmapMaterial = new BitmapMaterial(esferaBmp);
			//
			//Cria um shader.
			//var shader:GouraudShader = new GouraudShader(null, 0xFFFFFF, 0x000000);
			//var shader:FlatShader = new FlatShader(null, 0xFFFFFF, 0x000000);
			//
			//Cria um shadedMaterial para ser usado como material da esfera.
			//var shadedMaterial:ShadedMaterial = new ShadedMaterial(esferaMaterial, shader);
			//
			//if (cargaPositiva) {
				//trace(esfera.getMaterialByName("_02___Default"));
				//trace(esfera.getMaterialByName("_03___Default"));
				//esfera.replaceMaterialByName(shadedMaterial , "_02___Default");
				//esfera.material = shadedMaterial;
			//}
			//else {
				//trace(esfera.getMaterialByName("_02___Default"));
				//trace(esfera.getMaterialByName("_03___Default"));
				//esfera.replaceMaterialByName(shadedMaterial , "_03___Default");
				//esfera.material = shadedMaterial;
				//esfera.
			//}
			
			addChild(esfera);
			esfera.scale = 2;
			esfera.x = 300;
			esfera.rotationY = -90;
			//esfera.useOwnContainer = true;
		}
		
	}

}