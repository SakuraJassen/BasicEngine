using System.Collections;
using System;
using SDL2;
using BasicEngine.Interface;
using BasicEngine.Collections;
using System.Diagnostics;

namespace BasicEngine.GameStates
{
	class GameState : IDrawable, IUpdateable
	{
		public int mInputDelay = 0;
		public bool mCanDisplayPauseMenu = true;
		public bool mIsDisplayingPauseMenu = false;

		public bool mDisplayTipp = false;

		public List<int> mTrigger = new .();

		public ~this()
		{
			delete mTrigger;
		}

		// Update function for GameState
		public virtual void Update(int dt) { }

		//Basic Draw Implementation
		public virtual void Draw(int dt)
		{
			var totalEnities = 0;
			var totalParticles = 0;

			var drawHitbox = gEngineApp.mGameRules.GetRangeAsBool(Engine.GameRules.DebugShowHitbox);
			uint8 hitboxColorR = (uint8)gEngineApp.mGameRules.GetRange(Engine.GameRules.HitboxColor.R);
			uint8 hitboxColorG = (uint8)gEngineApp.mGameRules.GetRange(Engine.GameRules.HitboxColor.G);
			uint8 hitboxColorB = (uint8)gEngineApp.mGameRules.GetRange(Engine.GameRules.HitboxColor.B);
			drawHitbox = false;

			for (var layers in gEngineApp.mEntityList.mLayers)
			{
				totalEnities += layers.mEntities.Count;
				for (var entity in layers.mEntities)
					if (!entity.mIsDeleting)
					{
						entity.Draw(dt);

						if (drawHitbox)
							entity.DrawBoundingBox(hitboxColorR, hitboxColorG, hitboxColorB);
					}

				totalParticles += layers.mParticles.Count;
				for (var particle in layers.mParticles)
					if (!particle.mIsDeleting)
						particle.Draw(dt);
			}

			let avrgFrameTime = scope String()..Truncate(gEngineApp.mFPSCounter.GetAvrgFrameTime(), 2);
			var fps = scope String()..AppendF("FPS: {} ({}ms)", (int)gEngineApp.mFPSCounter.FPS, avrgFrameTime);
			if (gEngineApp.mGameRules.GetRangeAsBool(Engine.GameRules.DebugShowFPSInTitle))
			{
				gEngineApp.SetTitle(fps);
			}
			if (gEngineApp.mGameRules.GetRangeAsBool(Engine.GameRules.DebugDisplayInfos))
			{
				let spacing = 28;
				DrawUtils.DrawString(gEngineApp.mRenderer, gEngineApp.mFont, 8, 4 + (spacing * 0), fps, .(64, 255, 192, 255));
				DrawUtils.DrawString(gEngineApp.mRenderer, gEngineApp.mFont, 8, 4 + (spacing * 1), scope String()..AppendF("Entity CNT: {}", totalEnities), .(64, 255, 192, 255));
				DrawUtils.DrawString(gEngineApp.mRenderer, gEngineApp.mFont, 8, 4 + (spacing * 2), scope String()..AppendF("Particle CNT: {}", totalParticles), .(64, 255, 192, 255));
			}

			if (mCanDisplayPauseMenu && gEngineApp.mPause)
			{
				DrawPauseScreen();
				mIsDisplayingPauseMenu = true;
			} else
			{
				mIsDisplayingPauseMenu = false;
			}
		}

		public virtual void DrawPauseScreen()
		{
		}

		public virtual void InitGameRules()
		{
		}

		public virtual void MouseDown(SDL.MouseButtonEvent evt) { }
		public virtual void MouseUp(SDL.MouseButtonEvent evt) { }
		public virtual void MouseMotion(SDL.Event evt) { }

		public virtual void HandleInput() { }
		public virtual void HandleEvent(SDL.Event evt) { }
	}
}
