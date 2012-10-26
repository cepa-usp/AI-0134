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
		private var ponta:Cylinder;
		private var _orientation:int = 0;
		public function Arrow(color:uint = 0x0683FF) 
		{
			seta1 = new Cylinder(new ColorMaterial(color, 1), 4, 300, 6, 4);
			addChild(seta1)
			seta1.x = 0;
			seta1.y = 0;
			seta1.rotationX = 90;
			seta1.z = 150;
			
			ponta = new Cylinder(new ColorMaterial(color, 1), 8, 50, 10, 6, 0);
			addChild(ponta)
			ponta.x = 0;
			ponta.y = 0;
			ponta.localRotationX = 270;
			ponta.z = 325;
		}
		
		public function get orientation():int 
		{
			return _orientation;
		}
		
		public function set orientation(value:int):void 
		{
			_orientation = value;
		}
		
	}

}