package 
{	
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIInstance;
	import cepa.ai.AIObserver;
	import cepa.ai.IPlayInstance;
	import cepa.eval.ProgressiveEvaluator;
	import cepa.eval.StatsScreen;
	import cepa.utils.Angle;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import pipwerks.SCORM;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite implements AIObserver, AIInstance
	{
		
		private var screen:Screen = new Screen();
		private var timerToStart:Timer;
		private var menuBar:BarraMenuNew = new BarraMenuNew();
		private var menuNew:Boolean = true;
		private var ai:AI;
		private var resultScreen:ResultScreen = new ResultScreen();
		private var eval:ProgressiveEvaluator;
		private var statsScreen:StatsScreen;
		
		private var lyrMenu:Sprite = new Sprite();
		
		
		
		private function addLayers():void {

			
			lyrMenu.addChild(menuBar);
			menuBar.y = 479;
			menuBar.x = scrollRect.width/2
			
			ai.container.addChild(lyrMenu);
			
		}
		
		
		private function createAI():void {
			ai = new AI(this);
			eval = new ProgressiveEvaluator(ai);
			statsScreen = new StatsScreen(eval, ai);
			ai.evaluator = eval;
			ai.container.setAboutScreen(new AboutScreen134());
			ai.container.setInfoScreen(new InfoScreen134());
			ai.addObserver(this);
			ai.container.optionButtons.y = 10;
			ai.container.setMessageTextVisible(false);
			
		}
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onResetClick():void 
		{
			getNewExercise(null);
		}
		
		public function onScormFetch():void 
		{
			
		}
		
		public function onScormSave():void 
		{
			
		}
		
		public function onStatsClick():void 
		{
			statsScreen.openStatScreen();
		}
		
		public function onTutorialClick():void 
		{
			
		}
		
		public function onScormConnected():void 
		{
			
		}
		
		public function onScormConnectionError():void 
		{
			
		}
		
		/* INTERFACE cepa.ai.AIInstance */
		
		public function getData():Object 
		{
			return new Object();
		}
		
		public function readData(obj:Object) 
		{
			
		}
		
		public function createNewPlayInstance():IPlayInstance 
		{
			return new PlayInstance134();
		}
		
		private function init(e:Event = null):void 
		{			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			scrollRect = new Rectangle(0, 0, 700, 500);
			

			createAI();
			
			
			
			
			ai.container.addChild(screen);
			screen.y = -20;
			screen.camera.target = null;
			screen.startRendering();	
			screen.addEventListener(Event.COMPLETE, unlockButtons);
			
			
			addLayers();
			
			configMenu();
			timerToStart = new Timer(100, 1);
			timerToStart.addEventListener(TimerEvent.TIMER_COMPLETE, startAI, false, 0, true);
			timerToStart.start();
			
			//getNewExercise(null);
			resetMenu();
			
		}
		
		/**
		 * Trava os controles das flechas durante a animação de um novo exercício.
		 */
		private function lockButtons():void
		{
			if (eval.currentPlayMode == AIConstants.PLAYMODE_EVALUATE) {
				ai.container.disableComponent(menuBar.btValendo);				
			}
			rotLeft.flecha.mouseEnabled = false;
			rotRight.flecha.mouseEnabled = false;
			menuBar.btAvaliar.mouseEnabled = false;
		}
		
		/**
		 * Destrava os controles das flechas após um novo exercício iniciado.
		 */
		private function unlockButtons(e:Event):void 
		{
			if (menuNew) {
				rotLeft.flecha.mouseEnabled = true;
				rotRight.flecha.mouseEnabled = true;
				rotLeft.flecha.rotation = -90;
				rotRight.flecha.rotation = 90;
			}else{
				menuBar.btV1U.mouseEnabled = true;
				menuBar.btV1D.mouseEnabled = true;
				menuBar.btV2U.mouseEnabled = true;
				menuBar.btV2D.mouseEnabled = true;
			}
			screen.rotationEnabled = true;
			menuBar.btAvaliar.mouseEnabled = true;
		}
		
		private function startAI(e:TimerEvent):void 
		{
			timerToStart = null;
			screen.startExercise();
		}
		private var rotLeft:RotLeft;
		private var rotRight:RotRight;
		
		private function configMenu():void {
			//eventListener dos botões da moldura.

			menuBar.btNovamente.addEventListener(MouseEvent.CLICK, getNewExercise);
			menuBar.btAvaliar.addEventListener(MouseEvent.CLICK, aval);
			menuBar.btVerResposta.addEventListener(MouseEvent.CLICK, showHideAnswer);
			menuBar.btValendo.addEventListener(MouseEvent.CLICK, onValendoClick);
			
			
				rotLeft = new RotLeft();
				rotLeft.x = 3;
				rotLeft.y = 370;
				rotRight = new RotRight();
				rotRight.x = scrollRect.width;
				rotRight.y = 370;
				lyrMenu.addChild(rotLeft);
				lyrMenu.addChild(rotRight);
				
				rotLeft.flecha.addEventListener(MouseEvent.MOUSE_DOWN, initRotation);
				rotRight.flecha.addEventListener(MouseEvent.MOUSE_DOWN, initRotation);
			
				setButtonMode(menuBar.btAvaliar);
				setButtonMode(menuBar.btValendo);
				//setButtonMode(menuBar.btn_upDown);
				setButtonMode(menuBar.btNovamente);
				setButtonMode(menuBar.btVerResposta);
				
		}
		
		private function onValendoClick(e:MouseEvent):void 
		{
			ProgressiveEvaluator(ai.evaluator).askEvaluation(menuBar.btValendo, onEvalResponse);
		}
		
		public function setButtonMode(bt:MovieClip):void {
			bt.gotoAndStop(1);
			bt.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{bt.gotoAndStop(2)});
			bt.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {bt.gotoAndStop(1)});
			bt.buttonMode = true;
		}		
		
		public function onEvalResponse():void {
			trace("entrou callback", ProgressiveEvaluator(ai.evaluator).currentPlayMode)
			if (ProgressiveEvaluator(ai.evaluator).currentPlayMode == AIConstants.PLAYMODE_EVALUATE) {
				onResetClick();
			}
		}
		
		
		private var flechaRotacional:MovieClip;
		private function initRotation(e:MouseEvent):void 
		{
			flechaRotacional = MovieClip(e.target);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, rotating);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopRotating);
		}
		
		private var angle1:Angle = new Angle();
		private var angle2:Angle = new Angle();
		private function rotating(e:MouseEvent):void 
		{
			var posStage:Point = flechaRotacional.parent.localToGlobal(new Point(flechaRotacional.x, flechaRotacional.y));
			var angulo:int = Math.round((Math.atan2(stage.mouseY - posStage.y, stage.mouseX - posStage.x) * 180 / Math.PI + 90) / 10) * 10;
			angle1.degrees = angulo - 180;
			
			flechaRotacional.rotation = angulo;
			if (flechaRotacional.parent is RotLeft) {
				screen.selectedInstance.definePos_Seta1new(angle1.degrees);
			}else {
				screen.selectedInstance.definePos_Seta2new(angle1.degrees);
			}
		}
		
		private function stopRotating(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, rotating);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopRotating);
			
			flechaRotacional = null;
		}
		
		
		private function showAvalButtons():void {
			menuBar.btNovamente.visible = true;
			menuBar.btVerResposta.visible = true;
			menuBar.btVerResposta.verexerc.visible = false;
			menuBar.btAvaliar.visible = false;
		}
		
		/**
		 * Faz a avaliação da atividade
		 */
		private function aval(e:MouseEvent):void 
		{
			
			lockButtons();
			showAvalButtons();
			var play:PlayInstance134 = new PlayInstance134();
			
			//afterAvalClick();
			var currentScore:Number = screen.selectedInstance.getAnswer();
			play.setScore(currentScore / 100);
			
			var formatoErrado:TextFormat = new TextFormat();
			formatoErrado.color = 0xE67300;
			
			var formatoCerto:TextFormat = new TextFormat();
			formatoCerto.color = 0x008000;
			
			resultScreen.openScreen();
			if (currentScore == 0)	{
				resultScreen.result.defaultTextFormat = formatoErrado;
				resultScreen.result.text = "A orientação dos vetores precisa de revisão.";
				if(Math.random() > 0.5) resultScreen.texto.text = "Volte à atividade interativa e análise com calma a situação apresentada. Se você achar necessário, reveja o conceito e tente sanar suas dúvidas.";
				else resultScreen.texto.text = "Para que a atividade interativa possa colaborar para seu aprendizado, você precisa focar sua atenção na situação apresentada. Caso queira apoie-se no texto de referência e nos questionários para reforçar seu conhecimento. Retorne à atividade interativa após isso.";
			}else if (currentScore == 50) {
				resultScreen.result.defaultTextFormat = formatoErrado;
				resultScreen.result.text = "Apenas um vetor está posicionado corretamente.";
				if(Math.random() > 0.5) resultScreen.texto.text = "Para posicionar os dois vetores você precisa lembrar que (1) o momento angular é definido pela regra da mão direita, (2) que os dois vetores são paralelos e (3) que o sentido deles é igual se a carga for positiva, e oposto se a carga for negativa.";
				else resultScreen.texto.text = "Lembre-se de que (1) o momento angular é definido pela regra da mão direita, (2) que os dois vetores são paralelos e (3) que o sentido deles é igual se a carga for positiva, e oposto se a carga for negativa.";
			}else {
				resultScreen.result.defaultTextFormat = formatoCerto;
				resultScreen.result.text = "Você posicionou os vetores corretamente.";
				resultScreen.texto.text = "Clique \"Novo exercício\" para iniciar um novo exercício";
			}
			
			eval.addPlayInstance(play);
		}
		
		/**
		 * Mostra a resposta ao usuário, após realizada a avaliação.
		 */
		private function showHideAnswer(e:MouseEvent):void 
		{
			if (menuBar.btVerResposta.verresp.visible) {
				menuBar.btVerResposta.verresp.visible = false;
				menuBar.btVerResposta.verexerc.visible = true;
				//Mostra resposta:
				screen.selectedInstance.showAnswer();
			}else {
				menuBar.btVerResposta.verresp.visible = true;
				menuBar.btVerResposta.verexerc.visible = false;
				//Mostra o que o aluno fez:
				screen.selectedInstance.hideAnswer();
			}
		}
		
		private function defineSeta1Up(e:MouseEvent):void
		{
			screen.selectedInstance.definePos_Seta1(Instance.UP);
		}
		
		private function defineSeta1Down(e:MouseEvent):void
		{
			screen.selectedInstance.definePos_Seta1(Instance.DOWN);
		}
		
		private function defineSeta2Up(e:MouseEvent):void
		{
			screen.selectedInstance.definePos_Seta2(Instance.UP);
		}
		
		private function defineSeta2Down(e:MouseEvent):void
		{
			screen.selectedInstance.definePos_Seta2(Instance.DOWN);
		}
		
		private function getNewExercise(e:MouseEvent):void {
			resetMenu();
			lockButtons();

			screen.rotationEnabled = false;
			screen.getNewInstance();
		}
		
		private function resetMenu():void 
		{
			//menuBar.btVerResposta.verresp.visible = false;			
			menuBar.btVerResposta.visible = false;
			//menuBar.btAvaliar.x = 370;
			menuBar.btNovamente.visible = false;
			//menuBar.btVerResposta.verexerc.visible = false;
			
			menuBar.btAvaliar.mouseEnabled = true;
			
			menuBar.btAvaliar.visible = true;

		}
		
		
		/*------------------------------------------------------------------------------------------------*/
		//SCORM:
		
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var completed:Boolean;
		private var scorm:SCORM;
		private var scormExercise:int;
		private var connected:Boolean;
		private var score:Number = 0;
		private var pingTimer:Timer;
		private var mementoSerialized:String = "";
		
		
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			scorm = new SCORM();
			
			pingTimer = new Timer(PING_INTERVAL);
			pingTimer.addEventListener(TimerEvent.TIMER, pingLMS);
			
			connected = scorm.connect();
			
			if (connected) {
				// Verifica se a AI já foi concluída.
				var status:String = scorm.get("cmi.completion_status");	
				//mementoSerialized = String(scorm.get("cmi.suspend_data"));
				var stringScore:String = scorm.get("cmi.score.raw");
			 
				switch(status)
				{
					// Primeiro acesso à AI
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						break;
					
					// Continuando a AI...
					case "incomplete":
						completed = false;
						break;
					
					// A AI já foi completada.
					case "completed":
						completed = true;
						//setMessage("ATENÇÃO: esta Atividade Interativa já foi completada. Você pode refazê-la quantas vezes quiser, mas não valerá nota.");
						break;
				}
				
				//unmarshalObjects(mementoSerialized);
				scormExercise = 1;
				score = Number(stringScore.replace(",", "."));
				//txNota.text = score.toFixed(1).replace(".", ",");
				
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					pingTimer.start();
				}
				else
				{
					//trace("Falha ao enviar dados para o LMS.");
					connected = false;
				}
			}
			else
			{
				trace("Esta Atividade Interativa não está conectada a um LMS: seu aproveitamento nela NÃO será salvo.");
			}
			
			//reset();
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function commit():void
		{
			if (connected)
			{
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", score.toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				success = scorm.set("cmi.location", scormExercise.toString());
				
				// Salva no LMS a string que representa a situação atual da AI para ser recuperada posteriormente.
				//mementoSerialized = marshalObjects();
				//success = scorm.set("cmi.suspend_data", mementoSerialized.toString());

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					//setMessage("Falha na conexão com o LMS.");
					connected = false;
				}
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent):void
		{
			//scorm.get("cmi.completion_status");
			commit();
		}
		
		/*private function saveStatus():void
		{
			if(ExternalInterface.available){
				//mementoSerialized = marshalObjects();
				//scorm.set("cmi.suspend_data", mementoSerialized);
			}
		}*/
		
	}
	

}