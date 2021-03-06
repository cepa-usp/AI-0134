package  
{
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cylinder;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Arrow extends DisplayObject3D
	{
		private var seta1:Cylinder;
		private var _ponta:Cylinder;
		private var _orientation:int = 0;
		public function Arrow(color:uint = 0x0683FF) 
		{
			var calibre:int = 4;
			var tamanho:int = 300;
			if (color == 0x0683FF) {
					//calibre = 6;
					//tamanho = 270;
			}
			seta1 = new Cylinder(new ColorMaterial(color, 1), calibre, tamanho, 6, 4);
			addChild(seta1)
			seta1.x = 0;
			seta1.y = 0;
			seta1.rotationX = 90;
			seta1.z = 150;
			
			ponta = new Cylinder(new ColorMaterial(color, 1), calibre * 2, 50, 10, 6, 0);
			addChild(ponta)
			ponta.x = 0;
			ponta.y = 0;
			ponta.localRotationX = 270;
			ponta.z = tamanho + 25;
		}
		
		public function get orientation():int 
		{
			return _orientation;
		}
		
		public function set orientation(value:int):void 
		{
			_orientation = value;
		}
		
		public function get ponta():Cylinder 
		{
			return _ponta;
		}
		
		public function set ponta(value:Cylinder):void 
		{
			_ponta = value;
		}
		
	}

}