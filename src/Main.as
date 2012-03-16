package 
{
	import cepa.utils.ToolTip;
	import fl.controls.CheckBox;
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
			lupaMask.scaleX = lupaMask.scaleY = 0;
			
			setChildIndex(partGrandes, numChildren - 1);
			setChildIndex(lupa, numChildren - 1);
			setChildIndex(bordaAtividade, numChildren - 1);
			
			mudaEstadoParticulas(null);
			
			iniciaTutorial();
		}
		
		
		private function criaParticulasGrandes():void 
		{
			var i:int;
			for (i = 0; i < 50; i++) 
			{
				//trace(Math.floor(i % 5) + 1);
				var part:ParticulaGrande;
				if (Math.random() > 0.5) part = new ParticulaGrande(ParticulaGrande.CO2, areaArGrande, i/10 + Math.random());
				else part = new ParticulaGrande(Particula.H2, areaAr, Math.floor(i / 5) + 1 + Math.random());
				part.addEventListener(ParticulaGrande.DIE, criaNovaParticulaGrandeCima);
				partGrandes.addChild(part);
				//particulasAr.push(part);
				part.startMoving();
			}
			
			for (i = 0; i < 20; i++) 
			{
				var part2:ParticulaGrande = new ParticulaGrande(ParticulaGrande.H2O, areaAguaGrande, i/3 + Math.random());
				partGrandes.addChild(part2);
				part2.addEventListener(ParticulaGrande.DIE, criaNovaParticulaGrandeBaixo);
				//particulasAgua.push(part2);
				part2.startMoving();
			}
		}
		
		private function criaNovaParticulaGrandeCima(e:Event):void 
		{
			var partToRemove:ParticulaGrande = ParticulaGrande(e.target);
			partGrandes.removeChild(partToRemove);
			
			var part:ParticulaGrande;
			var type:String;
			
			if (Math.random() > 0.5) type = ParticulaGrande.CO2;
			else type = Particula.H2;
			
			if (type == ParticulaGrande.CO2) {
				part = new ParticulaGrande(ParticulaGrande.CO2, areaArGrande, 5, check_co2.selected);
			}else {
				part = new ParticulaGrande(ParticulaGrande.H2, areaArGrande, 5, check_h2o.selected);
			}
			
			part.addEventListener(ParticulaGrande.DIE, criaNovaParticulaGrandeCima);
			partGrandes.addChild(part);
			part.startMoving();
		}
		
		private function criaNovaParticulaGrandeBaixo(e:Event):void 
		{
			var partToRemove:ParticulaGrande = ParticulaGrande(e.target);
			partGrandes.removeChild(partToRemove);
			
			var part2:ParticulaGrande = new ParticulaGrande(ParticulaGrande.H2O, areaAguaGrande, 5, check_h2o.selected);
			partGrandes.addChild(part2);
			part2.addEventListener(ParticulaGrande.DIE, criaNovaParticulaGrandeBaixo);
			part2.startMoving();
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
			
			for (i = 0; i < 50; i++) 
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
			
			check_co2.label = "Marcar";
			check_h2o.label = "Marcar";
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
			
			check_co2.addEventListener(MouseEvent.CLICK, mudaEstadoParticulas);
			check_h2o.addEventListener(MouseEvent.CLICK, mudaEstadoParticulas);
			
			createToolTips();
		}
		
		private function mudaEstadoParticulas(e:MouseEvent):void 
		{
			h2oSel.visible = check_h2o.selected;
			h2oNormal.visible = !check_h2o.selected;
			co2Sel.visible = check_co2.selected;
			co2Normal.visible = !check_co2.selected;
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
			
			var infoO2:ToolTip = new ToolTip(check_h2o, "Marcar as moléculas de água com Oxigênio-18", 12, 0.8, 200, 0.6, 0.1);
			var infoC02:ToolTip = new ToolTip(check_co2, "Marcar as moléculas de dióxido de carbono com Oxigênio-18", 12, 0.8, 200, 0.6, 0.1);
			
			addChild(intTT);
			addChild(instTT);
			addChild(resetTT);
			addChild(infoTT);
			
			addChild(infoO2);
			addChild(infoC02);
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
		
		
		//Tutorial
		private var posQuadradoArraste:Point = new Point();
		private var balao:CaixaTexto;
		private var pointsTuto:Array;
		private var tutoBaloonPos:Array;
		private var tutoPos:int;
		private var tutoSequence:Array = ["Nesta atividade você deve reproduzir a experiência de Ruben e Kamen, indentificando a origem do oxigênio formado pela fotossíntese: a água ou o dióxido de carbono?",
										  "Neste recipiente há um pé de feijão exposto à luz e com suprimento controlado de dióxido de carbono e água.",
										  "Mova o mouse sobre o recipiente para \"ver\" mais de perto as moléculas.",
										  "Selecione para marcar o dióxido de carbono com o isótopo 18 do átomo Oxigênio.",
										  "Selecione para marcar as moléculas de oxigênio com o isótopo 18 do átomo Oxigênio."];
										  
		
		/**
		 * Inicia o tutorial da atividade.
		 */								  
		private function iniciaTutorial(e:MouseEvent = null):void 
		{
			tutoPos = 0;
			if(balao == null){
				balao = new CaixaTexto(true);
				addChild(balao);
				balao.visible = false;
				
				pointsTuto = 	[new Point(260, 160),
								new Point(250, 270),
								new Point(435, 270),
								new Point(check_co2.x + 12, check_co2.y + check_co2.height - 10),
								new Point(check_h2o.x + 12, check_h2o.y + check_h2o.height - 10)];
								
				tutoBaloonPos = [["" , ""],
								[CaixaTexto.RIGHT, CaixaTexto.CENTER],
								[CaixaTexto.LEFT, CaixaTexto.CENTER],
								[CaixaTexto.TOP, CaixaTexto.FIRST],
								[CaixaTexto.TOP, CaixaTexto.FIRST]];
			}
			
			balao.removeEventListener(Event.CLOSE, closeBalao);
			balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
			balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			balao.addEventListener(Event.CLOSE, closeBalao);
			balao.visible = true;
		}
		
		private function closeBalao(e:Event):void 
		{
			tutoPos++;
			if (tutoPos >= tutoSequence.length) {
				balao.removeEventListener(Event.CLOSE, closeBalao);
				balao.visible = false;
			}else {
				balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
				balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			}
		}
		
	}

}