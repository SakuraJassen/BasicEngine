using System;
using SDL2;
using BasicEngine.Entity;

namespace BasicEngine.HUD
{
	class DataLabel : Label
	{
		Object* mStringPointer ~ _ = null;

		private Font mFont ~ delete _;

		public this(Object* str, float x, float y, int32 fontSize = 16) : base("", x, y, fontSize)
		{
		}

		public ~this()
		{
		}

		public override void Draw(int dt)
		{
			SetString(ToStackString!(*mStringPointer));
			Log!([Friend]mStr);
			base.Draw(dt);
		}

		public override void Update(int dt)
		{
			base.Update(dt);
		}
	}
}
