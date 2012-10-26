package  
{
	import cepa.ai.IPlayInstance;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayInstance134 implements IPlayInstance 
	{
		private var _playMode:int;
		private var score:Number;
		
		
		public function PlayInstance134() 
		{
			
		}
		
		/* INTERFACE cepa.ai.IPlayInstance */
		
		public function get playMode():int 
		{
			return _playMode;
		}
		
		public function set playMode(value:int):void 
		{
			_playMode = value;
		}
		
		public function returnAsObject():Object 
		{
			var o:Object = new Object();
			o.playMode = this.playMode;
			o.score = this.score;
			return o;
		}
		
		public function bind(obj:Object):void 
		{
				this.playMode = obj.playMode;
				this.score = obj.score;
		}
		
		public function setScore(value:Number):void {
			score = value;
		}
		
		public function getScore():Number 
		{
			return score;
		}
		
		public function evaluate():void 
		{
			
		}
		
	}

}