using System;
namespace BasicEngine
{
	class FPSCounter
	{
		int64 _frames = 0;
		float _dt = 0.0f;
		float _fps = 0.0f;

		const int TOSTORE = 60;
		float[] _lastDeltaTimes = new float[TOSTORE];
		int _lastIndex = 0;

		public this()
		{
		}

		public ~this()
		{
			delete _lastDeltaTimes;
		}

		// dt: time passed since last frame
		// rate: how many times to update FPS per second
		public void Update(double dt, float rate = 5.0f)
		{
			++_frames;

			_dt += (float)dt * 0.001f;
			_lastDeltaTimes[_lastIndex++] = (float)dt;
			if (_lastIndex == TOSTORE)
				_lastIndex = 0;

			if (_dt > 1.0f / rate)
			{
				_fps = _frames / _dt;
				_dt -= 1.0f / rate;
				_frames = 0;
			}
		}


		public float FPS
		{
			get
			{
				return _fps;
			}
		}


		public float GetAvrgFrameTime()
		{
			float avrgTime = 0.0000001f;
			for (float f in _lastDeltaTimes)
				avrgTime += f;
			return avrgTime / TOSTORE;
		}
	}
}
