package
{
    import alecmce.console.signals.RegisterConsoleAction;
    import alecmce.console.view.ConsoleView;
    import alecmce.console.vo.ConsoleAction;
    import alecmce.entitysystem.extensions.view.Camera;
    import alecmce.entitysystem.extensions.view.display.DisplayUpdateSystem;
    import alecmce.fonts.BitmapFontDecoder;
    import alecmce.fonts.BitmapFonts;

    import org.swiftsuspenders.Injector;

    import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;

    import talk.commands.CreatePhysicsExampleCommand;
    import talk.commands.GotoSlideCommand;
    import talk.commands.MakeSlideEntitiesCommand;
    import talk.commands.PileAllRenderedEntitiesCommand;
    import talk.commands.SetupFontsCommand;
    import talk.commands.StartupCommand;
    import talk.factories.SlideCharacterEntityFactory;
    import talk.signals.CreatePhysicsExample;
    import talk.signals.GotoSlide;
    import talk.signals.MakeSlideEntities;
    import talk.signals.PileAllRenderedEntities;
    import talk.signals.SetupFonts;
    import talk.signals.Startup;
    import talk.systems.PileSystem;
    import talk.systems.SlideSelectionSystem;

    public class TalkConfig
    {
        [Inject]
        public var injector:Injector;

        [Inject]
        public var layers:Layers;

        [Inject]
        public var commandMap:ISignalCommandMap;

        [Inject]
        public var registerConsole:RegisterConsoleAction;

        [PostConstruct]
        public function setup():void
        {
            injector.map(SlideCharacterEntityFactory);
            injector.map(BitmapFontDecoder);

            injector.map(DisplayUpdateSystem).asSingleton();
            injector.map(BitmapFonts).asSingleton();

            injector.map(PileSystem).asSingleton();
            injector.map(SlideSelectionSystem).asSingleton();

            commandMap.map(Startup).toCommand(StartupCommand);
            commandMap.map(SetupFonts).toCommand(SetupFontsCommand);
            commandMap.map(MakeSlideEntities).toCommand(MakeSlideEntitiesCommand);
            commandMap.map(PileAllRenderedEntities).toCommand(PileAllRenderedEntitiesCommand);
            commandMap.map(CreatePhysicsExample).toCommand(CreatePhysicsExampleCommand);
            commandMap.map(GotoSlide).toCommand(GotoSlideCommand);

            layers.console.addChild(new ConsoleView());

            var camera:Camera = new Camera(0, 0, 800, 600);
            injector.map(Camera).toValue(camera);

            var action:ConsoleAction = new ConsoleAction();
            action.name = "pileAll";
            action.description = "add Piled component to all current entities";
            registerConsole.dispatch(action, injector.getInstance(PileAllRenderedEntities));

            var action:ConsoleAction = new ConsoleAction();
            action.name = "createPhysics";
            action.description = "creates a physics example";
            registerConsole.dispatch(action, injector.getInstance(CreatePhysicsExample));

            var action:ConsoleAction = new ConsoleAction();
            action.name = "gotoSlide";
            action.description = "goes to a given slide index";
            registerConsole.dispatch(action,  injector.getInstance(GotoSlide));
        }
    }
}