#pragma warning disable 162
using System;
using SDL2;
using System.Collections;

namespace BasicEngine
{
	static class ImagesDeprecated
	{
		public static Image sBkg;
		public static Image sSpaceImage;
		public static Image sExplosionImage;
		public static Image sHero;
		public static Image sSupport;
		public static Image sLaserBullet;
		public static Image sRocketBullet;

		public static struct Projectile
		{
			public static struct LaserBeam
			{
				public static Image Base;
				public static Image Head;
				public static Image Tail;
			}
		}

		public static struct PowerUp
		{
			public static Image sExit;
			public static Image sBasePowerUp;

			public static struct Commen {
				public static Image sAddSupport;
				public static Image sHealthUp;
				public static Image sShootDelayDown;
			}

			public static struct Rare {
				public static Image sTripleLaser;
				public static Image sRocketShot;
				public static Image sFastShot;
				public static Image sScatterShot;
			}
		}

		public static struct Enemy {
			public static Image sSkirmisher;
			public static Image sBomber;
			public static Image sLaser;
			public static Image sBomb;
			public static Image sPhaser;

			public static struct Goliath {
				public static Image sGoliath;
				public static Image sGoliathShield;
			}
		}

		static List<Image> sImages = new .() ~ delete _;

		public static Result<Image> Load(StringView fileName)
		{
			Image image = new Image();
			if (image.Load(fileName) case .Err)
			{
				delete image;
				return .Err;
			}
			sImages.Add(image);
			return image;
		}

		public static void Dispose()
		{
			ClearAndDeleteItems(sImages);
		}

		public static Result<void> Init()
		{
			Runtime.FatalError("deprecated");
			
			sBkg                           = Try!(Load("images/space.jpg"));
			sSpaceImage                    = Try!(Load("images/space.jpg"));
			sExplosionImage                = Try!(Load("images/explosion.png"));

			sHero                          = Try!(Load("images/Ship01.png"));
			sLaserBullet                   = Try!(Load("images/Bullet03.png"));
			sRocketBullet                  = Try!(Load("images/Bullet05.png"));
			sSupport                       = Try!(Load("images/Support.png"));

			Projectile.LaserBeam.Base 	   = Try!(Load("images/Projectile/LaserBeam/Base.png"));
			Projectile.LaserBeam.Head      = Try!(Load("images/Projectile/LaserBeam/Head.png"));
			Projectile.LaserBeam.Tail      = Try!(Load("images/Projectile/LaserBeam/Tail.png"));

			Enemy.sSkirmisher              = Try!(Load("images/Enemies/Ship01.png"));
			Enemy.Goliath.sGoliath         = Try!(Load("images/Enemies/Ship02.png"));
			Enemy.Goliath.sGoliathShield   = Try!(Load("images/Enemies/Ship02Shieldv2.png"));
			Enemy.sBomber                  = Try!(Load("images/Enemies/Ship03.png"));
			Enemy.sLaser                   = Try!(Load("images/Bullet02.png"));
			Enemy.sBomb                    = Try!(Load("images/Bullet01.png"));
			Enemy.sPhaser                  = Try!(Load("images/Bullet04.png"));

			PowerUp.sBasePowerUp           = Try!(Load("images/PowerUps/Base.png"));
			PowerUp.sExit                  = Try!(Load("images/PowerUps/Exit.png"));

			PowerUp.Commen.sHealthUp       = Try!(Load("images/PowerUps/Common/HealthUp.png"));
			PowerUp.Commen.sShootDelayDown = Try!(Load("images/PowerUps/Common/ShootDelayDown.png"));
			PowerUp.Commen.sAddSupport     = Try!(Load("images/PowerUps/Common/AddSupport.png"));

			PowerUp.Rare.sTripleLaser      = Try!(Load("images/PowerUps/Rare/TripleShot.png"));
			PowerUp.Rare.sRocketShot       = Try!(Load("images/PowerUps/Rare/RocketShot.png"));
			PowerUp.Rare.sFastShot         = Try!(Load("images/PowerUps/Rare/FastShot.png"));
			PowerUp.Rare.sScatterShot      = Try!(Load("images/PowerUps/Rare/ScatterShot.png"));


			return .Ok;
		}
	}
}
