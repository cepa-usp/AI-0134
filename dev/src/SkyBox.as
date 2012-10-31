package  
{
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	/**
	 * ...
	 * @author ...
	 */
	public class SkyBox extends Cube
	{
   
  
        public static const QUALITY_LOW:Number = 4;  
        public static const QUALITY_MEDIUM:Number = 6;  
        public static const QUALITY_HIGH:Number = 8;  
  
        public function SkyBox(bf:Class, bl:Class, bb:Class, bu:Class, br:Class, bd:Class, skysize:Number, quality:Number):void {  
            super(generateMaterials(bf, bl, bb, bu, br, bd), skysize, skysize, skysize, quality, quality, quality);  
        }  
  
        protected function generateMaterials(bf:Class, bl:Class, bb:Class, bu:Class, br:Class, bd:Class):MaterialsList {  
            var materials:MaterialsList = new MaterialsList();  
            materials.addMaterial(new BitmapMaterial(new bf().bitmapData), "front");  
            materials.addMaterial(new BitmapMaterial(new bl().bitmapData), "left");  
            materials.addMaterial(new BitmapMaterial(new bb().bitmapData), "back");  
            materials.addMaterial(new BitmapMaterial(new bu().bitmapData), "top");  
            materials.addMaterial(new BitmapMaterial(new br().bitmapData), "right");  
            materials.addMaterial(new BitmapMaterial(new bd().bitmapData), "bottom");  
  
            for each (var material:BitmapMaterial in materials.materialsByName) {  
                material.doubleSided = true;  
            }  
  
            return materials;  
        }  
    }  


}