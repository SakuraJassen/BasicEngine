using System;
namespace BasicEngine.Math.Raycast
{
	class Ray
	{
		public v2d<float> mPos;
		public v2d<float> mDir;

		public this(v2d<float> pos, float angle)
		{
			mPos = pos;
			mDir = .(Math.Cos(angle), Math.Sin(angle));
		}

		public Result<v2d<float>> GetIntersection(v2d<float> pos1, v2d<float> pos2)
		{
			var x1 = pos1.x;
			var y1 = pos1.y;
			var x2 = pos2.x;
			var y2 = pos2.y;

			var x3 = mPos.x;
			var y3 = mPos.y;
			var x4 = mDir.x;
			var y4 = mDir.y;

			var den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
			if (den == 0)
				return .Err((void)"den equals zero");

			var t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
			var u = -((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
			if (t > 0 && t < 1 && u > 1)
			{
				return .Ok(.(x1 + t * (x2 - x1), y1 + t * (y2 - y1)));
			}
			else
				return .Ok(.(-1, -1));
		}

	}
}
