using System;
using SDL2;
using System.Collections;

namespace BasicEngine.Sound
{
	static class Sounds
	{
		public static Sound sBeepMed;
		public static Sound sBeepHigh;
		public static Sound sBeepHighLong;
		public static Sound sFail;
		public static Sound sLaser;
		public static Sound sExplode;
		public static Sound sPowerUp;
		public static Sound sLaserCharge;
		public static Sound sLaserLoop;

		static List<Sound> sSounds = new .() ~ delete _;

		public static void Dispose()
		{
			ClearAndDeleteItems(sSounds);
		}

		public static Result<Sound> Load(StringView fileName)
		{
			Sound sound = new Sound();
			if (sound.Load(fileName) case .Err)
			{
				delete sound;
				return .Err;
			}
			sSounds.Add(sound);
			return sound;
		}

		public static Result<void> Init()
		{
			sBeepMed = Try!(Load("sounds/beep_med.wav"));
			sBeepHigh = Try!(Load("sounds/beep_high.wav"));
			sBeepHighLong = Try!(Load("sounds/beep_high_long.wav"));
			sFail = Try!(Load("sounds/fail.wav"));
			sLaser = Try!(Load("sounds/laser01.aiff"));
			sExplode = Try!(Load("sounds/explode01.wav"));
			sPowerUp = Try!(Load("sounds/power_up.wav"));
			sLaserCharge = Try!(Load("sounds/laser_charge.ogg"));
			sLaserLoop = Try!(Load("sounds/laser_looploop.wav"));
			return .Ok;
		}
	}
}
