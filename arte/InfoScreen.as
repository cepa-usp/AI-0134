<<<<<<< HEAD
package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class InfoScreen extends MovieClip
	{
		
		public function InfoScreen() 
		{
			this.x = 640 / 2;
			this.y = 480 / 2;
			
			this.gotoAndStop("END");
			
			this.addEventListener(MouseEvent.CLICK, closeScreen);
		}
		
		private function closeScreen(e:MouseEvent):void 
		{
			this.play();
		}
		
		public function openScreen():void
		{
			this.gotoAndStop("BEGIN");
		}
		
	}

=======
package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class InfoScreen extends MovieClip
	{
		
		public function InfoScreen() 
		{
			this.x = 640 / 2;
			this.y = 480 / 2;
			
			this.gotoAndStop("END");
			
			this.addEventListener(MouseEvent.CLICK, closeScreen);
		}
		
		private function closeScreen(e:MouseEvent):void 
		{
			this.play();
		}
		
		public function openScreen():void
		{
			this.gotoAndStop("BEGIN");
		}
		
	}

>>>>>>> 8756e5b21f570f1690c4e2363ce8f447345527a2
}