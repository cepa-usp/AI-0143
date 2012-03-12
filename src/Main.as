package 
{
	import cepa.utils.ToolTip;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends Sprite
	{
		/**
		 * Telas da atividade
		 */
		private var creditosScreen:AboutScreen;
		private var orientacoesScreen:InstScreen;
		private var feedbackScreen:FeedBackScreen;
		
		private var check_co2:CheckBox;
		private var check_h2o:CheckBox;
		private var slider_luz:Slider;
		
		private var particulasAr:Array = [];
		private var particulasAgua:Array = [];
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			scrollRect = new Rectangle(0, 0, 700, 500);
			
			makeLinks();
			criaTelas();
			
			adicionaListeners();
			criaParticulasPequenas();
			criaParticulasGrandes();
			
			MovieClip(partGrandes).mask = lupaMask;
			lupa.visible = false;
			
			setChildIndex(partGrandes, numChildren - 1);
			setChildIndex(lupa, numChildren - 1);
			setChildIndex(bordaAtividade, numChildren - 1);
		}
		
		private function criaParticulasGrandes():void 
		{
			var i:int;
			for (i = 0; i < 75; i++) 
			{
				var part:ParticulaGrande;
				if (Math.random() > 0.5) part = new ParticulaGrande(ParticulaGrande.CO2, areaArGrande);
				else part = new ParticulaGrande(Particula.H2, areaAr);
				partGrandes.addChild(part);
				//particulasAr.push(part);
				part.startMoving();
			}
			
			for (i = 0; i < 15; i++) 
			{
				var part2:ParticulaGrande = new ParticulaGrande(ParticulaGrande.H2O, areaAguaGrande);
				partGrandes.addChild(part2);
				//particulasAgua.push(part2);
				part2.startMoving();
			}
		}
		
		private function criaParticulasPequenas():void 
		{
			var i:int;
			for (i = 0; i < 150; i++) 
			{
				var part:Particula;
				if (Math.random() > 0.5) part = new Particula(Particula.CO2, areaAr);
				else part = new Particula(Particula.H2, areaAr);
				addChild(part);
				particulasAr.push(part);
				part.startMoving();
			}
			
			for (i = 0; i < 30; i++) 
			{
				var part2:Particula = new Particula(Particula.H2O, areaAgua);
				addChild(part2);
				particulasAgua.push(part2);
				part2.startMoving();
			}
		}
		
		private function makeLinks():void 
		{
			check_co2 = cb_co2;
			check_h2o = cb_h2o;
			slider_luz = sl_luz;
			
			check_co2.label = "Marcar";
			check_h2o.label = "Marcar";
			
			slider_luz.width = 200;
			slider_luz.minimum = 0;
			slider_luz.maximum = 100;
			slider_luz.tickInterval = 10;
			slider_luz.snapInterval = 1;
			slider_luz.liveDragging = true;
		}
		
		/**
		 * Cria as telas e adiciona no palco.
		 */
		private function criaTelas():void 
		{
			creditosScreen = new AboutScreen();
			addChild(creditosScreen);
			orientacoesScreen = new InstScreen();
			addChild(orientacoesScreen);
			feedbackScreen = new FeedBackScreen();
			addChild(feedbackScreen);
		}
		
		/**
		 * Adiciona os eventListeners nos botões.
		 */
		private function adicionaListeners():void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movingLupa);
			
			botoes.tutorialBtn.addEventListener(MouseEvent.CLICK, iniciaTutorial);
			botoes.orientacoesBtn.addEventListener(MouseEvent.CLICK, openOrientacoes);
			botoes.creditos.addEventListener(MouseEvent.CLICK, openCreditos);
			botoes.resetButton.addEventListener(MouseEvent.CLICK, reset);
			
			createToolTips();
		}
		
		private function movingLupa(e:MouseEvent):void 
		{
			//var mousePt:Point = new Point(mouseX, mouseY);
			lupa.x = stage.mouseX;
			lupa.y = stage.mouseY;
			lupaMask.x = stage.mouseX;
			lupaMask.y = stage.mouseY;
			if (MovieClip(areaAr).hitTestPoint(mouseX, mouseY, true) || MovieClip(areaAgua).hitTestPoint(mouseX, mouseY, true)) {
				if (lupa.visible == false) {
					Mouse.hide();
					lupa.visible = true;
					lupaMask.scaleX = lupaMask.scaleY = 1.5;
				}
			}else {
				if(lupa.visible){
					Mouse.show();
					lupa.visible = false;
					lupaMask.scaleX = lupaMask.scaleY = 0;
				}
			}
		}
		
		/**
		 * Cria os tooltips nos botões
		 */
		private function createToolTips():void 
		{
			var intTT:ToolTip = new ToolTip(botoes.tutorialBtn, "Reiniciar tutorial", 12, 0.8, 150, 0.6, 0.1);
			var instTT:ToolTip = new ToolTip(botoes.orientacoesBtn, "Orientações", 12, 0.8, 100, 0.6, 0.1);
			var resetTT:ToolTip = new ToolTip(botoes.resetButton, "Reiniciar", 12, 0.8, 100, 0.6, 0.1);
			var infoTT:ToolTip = new ToolTip(botoes.creditos, "Créditos", 12, 0.8, 100, 0.6, 0.1);
			
			addChild(intTT);
			addChild(instTT);
			addChild(resetTT);
			addChild(infoTT);
			
		}
		
		/**
		 * Inicia o tutorial da atividade.
		 */
		private function iniciaTutorial(e:MouseEvent):void 
		{
			
		}
		
		/**
		 * Abrea a tela de orientações.
		 */
		private function openOrientacoes(e:MouseEvent):void 
		{
			orientacoesScreen.openScreen();
			setChildIndex(orientacoesScreen, numChildren - 1);
			setChildIndex(bordaAtividade, numChildren - 1);
		}
		
		/**
		 * Abre a tela de créditos.
		 */
		private function openCreditos(e:MouseEvent):void 
		{
			creditosScreen.openScreen();
			setChildIndex(creditosScreen, numChildren - 1);
			setChildIndex(bordaAtividade, numChildren - 1);
		}
		
		/**
		 * Reinicia a atividade, colocando-a no seu estado inicial.
		 */
		private function reset(e:MouseEvent):void 
		{
			
		}
		
	}

}