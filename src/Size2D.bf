namespace BasicEngine
{
	class Size2D : Vector2D
	{
		public ref float Width
		{
			get
			{
				return ref mX;
			}
		}

		public ref float Height
		{
			get
			{
				return ref mY;
			}
		}

		public this(float width, float height) : base(width, height)
		{
		}

		public ~this(){
		}
	}
}
