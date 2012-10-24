package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class ResultScreen extends MovieClip
	{
		public function ResultScreen() 
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
		
		public function set resultado(value:String):void 
		{
			result.text = value;
		}
		
		public function set mensagem(value:String):void 
		{
			texto.text = value;
		}
		
	}

}