using System.Collections;
using SDL2;
using System;
using BasicEngine.Debug;
namespace BasicEngine
{
	class KeyboardManager
	{
		public typealias KeyFunctionRaw = delegate int(float delta);
		typealias KeyFunction = Event<KeyFunctionRaw>;
		Dictionary<int, KeyFunction> mKeyboardFunction = new Dictionary<int, KeyFunction>() ~ SafeDelete!(_);
		public const int DELTA_Normal = 1;
		public const int DELTA_Shift = 5;
		public const int DELTA_Alt = 10;
		public const int DELTA_Ctrl = 10;

		int _delay = 0;
		public int KeyPressDelay
		{
			get
			{
				return _delay;
			}
			set
			{
				_delay = value;
			}
		};

		public this()
		{
		}

		public ~this()
		{
			for (var event in mKeyboardFunction.Values)
			{
				event.Dispose();
			}
		}

		public Result<void> AddKey(SDL.Scancode scancode, KeyFunctionRaw func)
		{
			if (!mKeyboardFunction.TryAdd((int)scancode, KeyFunction()))
			{
				return .Err((void)null);
			}
			mKeyboardFunction[(int)scancode].Add(func);
			return .Ok((void)null);
		}

		public void ClearKey(SDL.Scancode scancode)
		{
			mKeyboardFunction[(int)scancode].Dispose();
			mKeyboardFunction.Remove((int)scancode);
			mKeyboardFunction.TryAdd((int)scancode, KeyFunction());
		}

		[Inline]
		public bool KeyDown(SDL.Scancode scancode)
		{
			return gEngineApp.mKeyboardState[(int)scancode];
		}

		[Inline]
		public bool KeyDown(int scancode)
		{
			return gEngineApp.mKeyboardState[scancode];
		}

		public float getDelta()
		{
			float delta = DELTA_Normal;
			if (KeyDown(.LShift))
				delta *= DELTA_Shift;
			if (KeyDown(.LAlt))
				delta /= DELTA_Alt;
			if (KeyDown(.LCtrl))
				delta *= DELTA_Ctrl;

			return delta;
		}

		public Result<void> HandleInput()
		{
			if (--_delay > 0)
				return .Ok((void)null);

			if (gEngineApp.mKeyboardState == null)
				return .Err((void)null);

			var delta = getDelta();
			for (var keyValuePair in mKeyboardFunction.GetEnumerator())
			{
				int scancode = keyValuePair.key;
				KeyFunction keyFunc = keyValuePair.value;

				if (KeyDown(scancode))
				{
					Logger.Debug((SDL.Scancode)scancode);
					var delay = keyFunc(delta);
					if (delay > _delay)
						_delay = delay;
				}
			}
			return .Ok((void)null);
		}

		public int HandlePanAndZoom(SDLCamera cam)
		{
			var delta = getDelta();
			int found = 0;
			if (KeyDown(.Q))
			{
				cam.mScale = Math.Max(cam.mScale - (0.01f * delta), 0.1f);
				Logger.Info("zoom", cam.mScale);
				found = 5;
			}
			else if (KeyDown(.E))
			{
				cam.mScale += (0.01f * delta);
				Logger.Info("zoom", cam.mScale);
				found = 5;
			}

			if (KeyDown(.S))
			{
				cam.mPos.mY -= delta;
				found = 1;
			}
			else if (KeyDown(.W))
			{
				cam.mPos.mY += delta;
				found = 1;
			}

			if (KeyDown(.D))
			{
				cam.mPos.mX -= delta;
				found = 1;
			}
			else if (KeyDown(.A))
			{
				cam.mPos.mX += delta;
				found = 1;
			}

			if (KeyDown(.F))
			{
				cam.Reset();
				found = 5;
			}

			return found;
		}
	}
}
