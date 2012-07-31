package talk.commands
{
    import alecmce.entitysystem.extensions.view.Position;
    import alecmce.entitysystem.framework.Entities;
    import alecmce.entitysystem.framework.Entity;
    import alecmce.fonts.BitmapFonts;

    import talk.data.Slide;
    import talk.data.SlideImage;
    import talk.factories.SlideCharacterEntityFactory;

    public class MakeSlideStepCommand
    {
        [Inject]
        public var fonts:BitmapFonts;

        [Inject]
        public var characterFactory:SlideCharacterEntityFactory;

        [Inject]
        public var entities:Entities;

        [Inject]
        public var slide:Slide;

        public function execute():void
        {
            makeImageEntities();
            addEntities();
        }

        private function makeImageEntities():void
        {
            var images:Vector.<SlideImage> = slide.images;
            if (!images)
                return;

            for each (var image:SlideImage in slide.images)
            {
                if (image.step == slide.step)
                    makeImageEntity(image);
            }
        }

        private function makeImageEntity(image:SlideImage):void
        {
            var position:Position = new Position();
            position.x = image.x + slide.x;
            position.y = image.y + slide.y;

            var entity:Entity = new Entity();
            entity.add(position);
            entity.add(image.data);

            entities.addEntity(entity);
        }

        private function addEntities():void
        {
            var list:Vector.<Entity> = characterFactory.make(slide);
            for each (var entity:Entity in list)
                entities.addEntity(entity);
        }

    }
}
