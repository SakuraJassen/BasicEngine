using SDL2;
using BasicEngine.Entity;
using System;
using System.Diagnostics;

namespace BasicEngine
{
	/// A simple animation class which takes a Sprite sheet and returns the current Sprite as an Image.
	class Animation
	{
		///*
		// mSizeScale
		//   This member is used to up- and downscale the resulting Sprite.
		///*
		public float mSizeScale;

		///*
		// mSpeedScale
		//   The member mUpdateCount gets multiplied by mSpeedScale to speed up or slow down the Animation.
		///*
		public float mSpeedScale;

		///*
		// mSpriteSheet
		//   The Image of all of the Sprites.
		///*
		public Image mSpriteSheet;

		///*
		// mSize
		//   The amount of Sprites on the Sprite sheet.
		///*
		public Size2D mSpriteCounts;

		///*
		// mUpdateCount
		//   The number of Update() calls.
		//   This member gets incremented every time the Function Update() gets called.
		//   SetFrame 
		///*
		private int mUpdateCount = 0;
		public int UpdateCount
		{
			get { return mUpdateCount; }
		}

		///*
		// mFrameCount
		//   how many frames the Animation has.
		///*
		public int mTotalFrameCount;

		///*
		// mLoop
		//   Should the animation automatically start over?
		///*
		public bool mLoop = false;

		///*
		// mFinished
		//   mFinished gets set to true when the current frame equal to mTotalFrameCount.
		//   Never gets set when mLoop is true.
		///*
		private bool mFinished = false;
		public bool AnimationFinished
		{
			get { return mFinished; }
		}

		///*
		// mFinished
		//   How many individual Sprite the Sprite sheet has.
		///*
		private int mSp;
		public int TotalSprites
		{
			get { return mSp; }
		}

		///*
		// this
		//    Full initialization of all Members.
		///*
		public this(Image spriteSheet, Size2D size, int sC, int frameCount, float speedScale = 1f, float sizeScale = 1f)
		{
			mSpriteSheet = spriteSheet;
			mSpriteCounts = size;
			mSp = sC;
			mSpeedScale = speedScale;
			mSizeScale = sizeScale;
			mTotalFrameCount = frameCount;
		}

		///*
		// ~this
		//    Sets mSpriteSheet to null because ResourceLoader will delete the Image.
		///*
		public ~this()
		{
			mSpriteSheet = null;
			SafeDelete!(mSpriteCounts);
		}

		// Current frame
		///*
		// Frame
		///*
		// Return:
		//   Frame returns the current number of updates multiplied by the speed scale which is clamped between zero and the TotalFrameCount.
		///*
		public int32 Frame
		{
			get
			{
				return (int32)Math.Clamp((mSpeedScale * mUpdateCount), 0, mTotalFrameCount);
			}
		}

		///*
		// []
		//    Gets the source rectangle of the current Sprite on the current Sprite sheets
		///*
		// Parameter:
		//   frame: the index of the Sprite from left to right and top to bottom.
		///*
		// Return:
		//   The rectangle of the current Sprite.
		///*
		public SDL.Rect this[int frame]
		{
			get
			{
				return SDL.Rect((int32)(frame % mSpriteCounts.Width) * (int32)mSpriteCounts.Width, (int32)(frame / mSpriteCounts.Width) * (int32)mSpriteCounts.Height, (int32)mSpriteCounts.Width, (int32)mSpriteCounts.Height);
			}
		}

		///*
		// SetFrame
		//    Sets the current frame to the first parameter divided by the Speed scale. 
		///*
		// Parameter:
		//   i: to which mUpdateCount gets set.
		///*
		// Return:
		//   -
		///*
		public void SetFrame(int i)
		{
			Debug.Assert(i > 0 && i <= mTotalFrameCount);
			mUpdateCount = (int)(i / mSpeedScale);
		}

		///*
		// Update
		//    Update gets called every frame except when logic is suspended. 
		///*
		public void Update()
		{
			mUpdateCount++;
			if (Frame >= mTotalFrameCount)
			{
				if (mLoop)
					mUpdateCount = 0;
				else
					mFinished = true;
			}
		}

		///*
		// Draw
		//    Draw contains all of the draw logic and gets called every frame.
		///*
		public void Draw(Vector2D pos)
		{
			let image = mSpriteSheet;
			float x = pos.mX - (mSpriteCounts.Width / 2 * mSizeScale);
			float y = pos.mY - (mSpriteCounts.Height / 2 * mSizeScale);

			SDL.Rect srcRect = this[Frame];
			SDL.Rect destRect = .((int32)x, (int32)y, (int32)(mSizeScale * mSpriteCounts.Width), (int32)(mSizeScale * mSpriteCounts.Height));
			SDL.RenderCopy(gEngineApp.mRenderer, image.mTexture, &srcRect, &destRect);
		}
	}
}
