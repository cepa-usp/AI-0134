package {
	import cepa.utils.ToolTip;
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class AtividadeInterativa extends MovieClip
	{
		//Telas de informações e CC
		private var infoScreen:InfoScreen;
		private var aboutScreen:AboutScreen;
		public var resultScreen:ResultScreen;
		
		//Botões padrão
		private var btn_Reset:Btn_Reset;
		private var btn_Instructions:Btn_Instructions;
		private var btn_CC:Btn_CC;
		
		//Moldura padrão
		private var moldura:Moldura;
		
		//Barra de menu padrão
		private var _menuBar:MovieClip;
		
		//Camadas
		private var cmd_Buttons:Sprite;
		private var cmd_Moldura:Sprite;
		public var cmd_Menu:Sprite;
		public var cmd_Atividade:Sprite;
		public var cmd_Screen:Sprite;
		public var menuNew:Boolean = true;
		
		public function AtividadeInterativa() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.scrollRect = new Rectangle(0, 0, 640, 480);			
			createLayers();		
			configStage();			
			addPointingArrow();
		}
		
		private var pointingArrow:PointingArrow;
		private function addPointingArrow():void 
		{
			pointingArrow = new PointingArrow();
			pointingArrow.x = 640 - 25;
			pointingArrow.y = 25;
			pointingArrow.filters = [new GlowFilter(0x800000, 1, 10, 10)];
			stage.addChild(pointingArrow);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, removeArrow);
		}
		
		private function removeArrow(e:MouseEvent):void
		{
			if (pointingArrow == null) return;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, removeArrow);
			stage.removeChild(pointingArrow);
			pointingArrow = null;
		}
		
		private function createLayers():void
		{
			cmd_Atividade = new Sprite();
			cmd_Buttons = new Sprite();
			cmd_Menu = new Sprite();
			cmd_Moldura = new Sprite();
			cmd_Screen = new Sprite();
			orderLayers();
		}
		
		public function orderLayers():void {
			addChild(cmd_Atividade);
			addChild(cmd_Menu);
			addChild(cmd_Moldura);
			addChild(cmd_Buttons);
			addChild(cmd_Screen);
			
		}
		
		private function configStage():void
		{
			configMenuBar();
			
			moldura = new Moldura();
			cmd_Moldura.addChild(moldura);
			
			btn_Instructions = new Btn_Instructions();
			btn_CC = new Btn_CC();
			btn_Reset = new Btn_Reset();
			cmd_Buttons.addChild(btn_Instructions);
			cmd_Buttons.addChild(btn_CC);
			cmd_Buttons.addChild(btn_Reset);
			
			var ttInst:ToolTip = new ToolTip(btn_Instructions, "Ajuda", 12, 0.8, 100, 0.6, 0.6);
			var ttCred:ToolTip = new ToolTip(btn_CC, "Créditos", 12, 0.8, 100, 0.6, 0.6);
			var ttReset:ToolTip = new ToolTip(btn_Reset, "Nova tentativa", 12, 0.8, 200, 0.6, 0.6);
			
			stage.addChild(ttInst);
			stage.addChild(ttCred);
			stage.addChild(ttReset);
			
			btn_Instructions.x = 629.2;
			btn_Instructions.y = 25;
			btn_Instructions.addEventListener(MouseEvent.CLICK, showInstructions);
			
			btn_CC.x = 629.2;
			btn_CC.y = 52;
			btn_CC.addEventListener(MouseEvent.CLICK, showCC);
			
			btn_Reset.x = 629.2;
			btn_Reset.y = 79;
			
			infoScreen = new InfoScreen();
			cmd_Screen.addChild(infoScreen);
			
			aboutScreen = new AboutScreen();
			cmd_Screen.addChild(aboutScreen);
			
			resultScreen = new ResultScreen();
			cmd_Screen.addChild(resultScreen);
		}
		
		private function showCC(e:MouseEvent):void 
		{
			aboutScreen.openScreen();
		}
		
		private function showInstructions(e:MouseEvent):void 
		{
			infoScreen.openScreen();
		}
		
		public function get menuBar():MovieClip 
		{
			return _menuBar;
		}
		
		public function set menuBar(value:MovieClip):void 
		{
			_menuBar = value;
		}
		
		public function get Atividade():Sprite 
		{
			return cmd_Atividade;
		}
		
		public function set Atividade(value:Sprite):void 
		{
			cmd_Atividade = value;
		}
		
		public function get btnReset():Btn_Reset 
		{
			return btn_Reset;
		}
		
		public function set btnReset(value:Btn_Reset):void 
		{
			btn_Reset = value;
		}
		
		public function get btnCC():Btn_CC 
		{
			return btn_CC;
		}
		
		public function set btnCC(value:Btn_CC):void 
		{
			btn_CC = value;
		}
		
		public function get btnInstructions():Btn_Instructions 
		{
			return btn_Instructions;
		}
		
		public function set btnInstructions(value:Btn_Instructions):void 
		{
			btn_Instructions = value;
		}
		
		private function configMenuBar():void 
		{
			if (menuNew) {
				menuBar = new BarraMenuNew();
				menuBar.y = 440;
			}else{
				menuBar = new MenuBar();
				menuBar.y = 420;
			}
			cmd_Menu.addChild(menuBar);
			menuBar.btn_upDown.gotoAndStop("FECHAR");
			menuBar.btn_upDown.visible = false;
			
			menuBar.btn_upDown.buttonMode = true;
			menuBar.btn_upDown.addEventListener(MouseEvent.CLICK, openCloseMenuBar);
			
			setButtonMode(menuBar.btAvaliar);
			setButtonMode(menuBar.btNovamente);
			setButtonMode(menuBar.btVerResposta);
			
			menuBar.btNovamente.visible = false;
			menuBar.btVerResposta.visible = false;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btVerResposta.verresp.visible = true;
			
			addToolTips();
		}
		
		public function setButtonMode(bt:MovieClip):void {
			bt.gotoAndStop(1);
			bt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{bt.gotoAndStop(2)});
			bt.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {bt.gotoAndStop(1)});
			bt.buttonMode = true;
		}
		
		private function addToolTips():void
		{
			var ttAvaliar:ToolTip = new ToolTip(menuBar.btAvaliar, "Avaliar exercício", 12, 0.8, 200, 0.6, 0.6);
			var ttNovamente:ToolTip = new ToolTip(menuBar.btNovamente, "Nova tentativa", 12, 0.8, 200, 0.6, 0.6);
			var ttVerResp:ToolTip = new ToolTip(menuBar.btVerResposta, "Mostrar/esconder resposta", 12, 0.8, 250, 0.6, 0.6);
			
			stage.addChild(ttAvaliar);
			stage.addChild(ttNovamente);
			stage.addChild(ttVerResp);
		}
		
		private var menuOpen:Boolean = true;
		private var tweenMenu:Tween;

		private function openCloseMenuBar(e:MouseEvent):void
		{
			if (menuNew) {
				if(menuOpen){
					menuOpen = false;
					tweenMenu = new Tween(menuBar, "y", None.easeNone, menuBar.y, 476, 0.3, true);
				}else{
					menuOpen = true;
					tweenMenu = new Tween(menuBar, "y", None.easeNone, menuBar.y, 440, 0.3, true);
				}
			}else{
				if(menuOpen){
					menuOpen = false;
					tweenMenu = new Tween(menuBar, "y", None.easeNone, menuBar.y, 476, 0.3, true);
				}else{
					menuOpen = true;
					tweenMenu = new Tween(menuBar, "y", None.easeNone, menuBar.y, 420, 0.3, true);
				}
			}
			tweenMenu.addEventListener(TweenEvent.MOTION_FINISH, changeBtnUpDown);
		}
		
		private function changeBtnUpDown(e:TweenEvent):void 
		{
			if(menuOpen){
				menuBar.btn_upDown.gotoAndStop("FECHAR");
			}else{
				menuBar.btn_upDown.gotoAndStop("ABRIR");
			}
		}
		
		public function resetMenu():void
		{
			menuBar.btAvaliar.visible = true;
			menuBar.btNovamente.visible = false;
			menuBar.btVerResposta.visible = false;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btVerResposta.verresp.visible = true;
		}
		
		public function afterAvalClick():void
		{
			menuBar.btAvaliar.visible = false;
			menuBar.btNovamente.visible = true;
			menuBar.btVerResposta.visible = true;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btVerResposta.verresp.visible = true;
		}
		
	}
	
}