package 
{
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
	public class Main extends AtividadeInterativa 
	{
		
		private var screen:Screen = new Screen();
		private var timerToStart:Timer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			scrollRect = new Rectangle(0, 0, 640, 480);
			
			cmd_Atividade.addChild(screen);
			screen.y = -20;
			screen.camera.target = null;
			screen.startRendering();	
			screen.addEventListener(Event.COMPLETE, unlockButtons);
			
			configMenu();
			timerToStart = new Timer(100, 1);
			timerToStart.addEventListener(TimerEvent.TIMER_COMPLETE, startAI, false, 0, true);
			timerToStart.start();
			
			if (ExternalInterface.available) initLMSConnection();
		}
		
		/**
		 * Trava os controles das flechas durante a animação de um novo exercício.
		 */
		private function lockButtons():void
		{
			if (menuNew) {
				rotLeft.flecha.mouseEnabled = false;
				rotRight.flecha.mouseEnabled = false;
			}else{
				menuBar.btV1U.mouseEnabled = false;
				menuBar.btV1D.mouseEnabled = false;
				menuBar.btV2U.mouseEnabled = false;
				menuBar.btV2D.mouseEnabled = false;
			}
			//screen.rotationEnabled = false;
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
			btnReset.addEventListener(MouseEvent.CLICK, getNewExercise);
			menuBar.btNovamente.addEventListener(MouseEvent.CLICK, getNewExercise);
			menuBar.btAvaliar.addEventListener(MouseEvent.CLICK, aval);
			menuBar.btVerResposta.addEventListener(MouseEvent.CLICK, showHideAnswer);
			
			if (menuNew) {
				rotLeft = new RotLeft();
				rotLeft.x = 3;
				rotLeft.y = 350;
				rotRight = new RotRight();
				rotRight.x = 637;
				rotRight.y = 350;
				cmd_Menu.addChild(rotLeft);
				cmd_Menu.addChild(rotRight);
				
				rotLeft.flecha.addEventListener(MouseEvent.MOUSE_DOWN, initRotation);
				rotRight.flecha.addEventListener(MouseEvent.MOUSE_DOWN, initRotation);
			}else{
				menuBar.btV1U.addEventListener(MouseEvent.CLICK, defineSeta1Up);
				menuBar.btV1D.addEventListener(MouseEvent.CLICK, defineSeta1Down);
				menuBar.btV2U.addEventListener(MouseEvent.CLICK, defineSeta2Up);
				menuBar.btV2D.addEventListener(MouseEvent.CLICK, defineSeta2Down);
				
				setButtonMode(menuBar.btV1U);
				setButtonMode(menuBar.btV1D);
				setButtonMode(menuBar.btV2U);
				setButtonMode(menuBar.btV2D);
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
		
		/**
		 * Faz a avaliação da atividade
		 */
		private function aval(e:MouseEvent):void 
		{
			lockButtons();
			afterAvalClick();
			var currentScore:Number = screen.selectedInstance.getAnswer();
			
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
			
			if (!completed) {
				score = currentScore;
				completed = true;
				commit();
			}else{
				if (currentScore > score) {
					score = currentScore;
					completed = true;
					commit();
				}
			}
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