namespace BasicEngine
{
	///*
	// Direction is a small struct to store a 8-Way direction.
	///*
	struct Direction
	{
		public uint mMovingFlags = 0;

		public const uint No         = (uint)0b0000;
		public const uint Up         = (uint)0b0001;
		public const uint Down       = (uint)0b0010;
		public const uint Left       = (uint)0b0100;
		public const uint Right      = (uint)0b1000;
		public const uint Vertical   = Up   | Down;
		public const uint Horizontal = Left | Right;

		public static mixin IsFacingTheSameDirection(uint lh, uint rh)
		{
			((lh & rh) == rh)
		}

		public static bool operator==(Direction lhs, Direction rhs) {
			return IsFacingTheSameDirection!(lhs.mMovingFlags, rhs.mMovingFlags);
		}

		public static bool operator==(Direction lhs, uint rhs) {
			return IsFacingTheSameDirection!(lhs.mMovingFlags, rhs);
		}
	}
}
