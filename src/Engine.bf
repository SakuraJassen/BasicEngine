using System;
using SDL2;
using System.Collections;
using BasicEngine.GameStates;
using System.Diagnostics;
using BasicEngine.Particle;
using BasicEngine.Interface;
using BasicEngine.LayeredList;
using BasicEngine.Sound;
using BasicEngine.Entity;
using BasicEngine.Console;
using BasicEngine.Collections;
using BasicEngine.Debug;

namespace BasicEngine
{
	static
	{
		public static Engine gEngineApp;
	}

	///*
	// The base Object of this Engine.
	///*
	class Engine : SDLApp
	{
		///*
		// mEntitieList
		//   The main Entity List. Every frame the Entities in the List get Updated and Drawn.
		//   Contains 10 List to separate them by layers.
		///*
		public LayeredList mEntityList = new LayeredList() ~ DeleteAndNullify!(_);

		///*
		// mRand
		//   The main Random object to ensure proper seeding.
		///*
		public Random mRand = new Random() ~ delete _;

		///*
		// mFont
		//   The default Font.
		///*
		public Font mFont ~ delete _;

		///*
		// mPause
		//   When set to true all updates calls get suspended.
		///*
		public bool mPause = false;

		///*
		// mFrameAdvance
		//   Gets set to false every frame.
		//   When mFrameAdvance gets set to true it will cause one updates call to be executed.
		///*
		public bool mFrameAdvance = false;

		///*
		// mQuit
		//   When set to true, the program will exit.
		///*
		public bool mQuit = false;

		///*
		// mGameState
		//   The GameState which is currently active.
		///*
		public GameState mGameState;

		///*
		// mCmd
		//   The Handler for the incoming Commands from the remote Console.
		///*
		public CommandHandler mCmd = null ~ delete _;

		///*
		// mFPSCounter
		//   global FPS Counter
		///*
		public FPSCounter mFPSCounter = new FPSCounter();

		///*
		// mLogicCycleCounter
		//   gets incremented in every logic update
		///*
		public uint64 mLogicCycleCounter = 0;

		///*
		// mDrawCycleCounter
		//   get incremented in every draw update
		///*
		public uint64 mDrawCycleCounter = 0;

		///*
		// mGameRules
		//   A bit array which contains dynamic values.
		///*
		public var mGameRules = new BitArray() ~ delete _;

		///*
		// The class GameRules contains misc NamedIndexes related to debugging
		///*
		public static class GameRules
		{
			public static NamedIndex Debug = null;
			public static NamedIndex DebugDisplayInfos = null;
			public static NamedIndex DebugShowFPSInTitle = null;
			public static NamedIndex DebugTimeLogic = null;
			public static NamedIndex DebugShowHitbox = null;
			public static NamedIndex DebugTimeDraw = null;
			public static class HitboxColor
			{
				public static NamedIndex R = null;
				public static NamedIndex G = null;
				public static NamedIndex B = null;
			}
		}

		///*
		// this
		//   Initializes the static global Variable gEngineApp with a reference to itself.
		///*
		// Parameter:
		//   -
		///*
		public this()
		{
			gEngineApp = this;
		}

		///*
		// ~this
		//   Disposes of globally loaded Resources .
		///*
		// Parameter:
		//   -
		///*
		public ~this()
		{
			Sounds.Dispose();

			delete mGameState;
			delete mFPSCounter;
		}

		///*
		// init
		//   The Method loads resources and setups the initial state.
		//   Has to be called Manuel.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public new void Init()
		{
			base.Init();
			mFont = new Font();
			mFont.Load("zorque.ttf", 24);

			mGameState = new GameState();

			Engine.GameRules.Debug = gEngineApp.mGameRules.mNamedIndices.AddSized("Debug", 1);
			Engine.GameRules.DebugShowHitbox = gEngineApp.mGameRules.mNamedIndices.AddSized("DebugShowHitbox", 1);
			Engine.GameRules.HitboxColor.R = gEngineApp.mGameRules.mNamedIndices.AddSized("DebugShowHitboxR", 8);
			Engine.GameRules.HitboxColor.G = gEngineApp.mGameRules.mNamedIndices.AddSized("DebugShowHitboxG", 8);
			Engine.GameRules.HitboxColor.B = gEngineApp.mGameRules.mNamedIndices.AddSized("DebugShowHitboxB", 8);
			Engine.GameRules.DebugDisplayInfos = gEngineApp.mGameRules.mNamedIndices.AddSized("DisplayDebug", 1);
			Engine.GameRules.DebugShowFPSInTitle = gEngineApp.mGameRules.mNamedIndices.AddSized("DebugShowFPS", sizeof(bool));
			Engine.GameRules.DebugTimeLogic = gEngineApp.mGameRules.mNamedIndices.AddSized("DebugTimeLogic", sizeof(bool));
			Engine.GameRules.DebugTimeDraw = gEngineApp.mGameRules.mNamedIndices.AddSized("DebugTimeDraw", sizeof(bool));

#if DEBUG
			gEngineApp.mGameRules.SetRange(Engine.GameRules.Debug, 1);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugShowHitbox, 0);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.HitboxColor.R, 0xAA);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.HitboxColor.G, 0xFF);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.HitboxColor.B, 0xAA);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugDisplayInfos, 1);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugShowFPSInTitle, 1);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugTimeLogic, 0);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugTimeDraw, 0);

#else
			gEngineApp.mGameRules.SetRange(Engine.GameRules.Debug, 0);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugShowHitbox, 0);
			gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugDisplayInfos, 0);
#endif

			mGameState.InitGameRules();
		}

		///*
		// AddEntity
		//   Adds a entity to the main entity list.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public void AddEntity(Entity entity)
		{
			mEntityList.AddEntity(entity, entity.mLayer);
		}

		public void AddEntityFront(Entity entity)
		{
			mEntityList.AddEntityFront(entity, entity.mLayer);
		}

		public void AddParticle(Particle particle)
		{
			mEntityList.AddParticle(particle, particle.mLayer);
		}

		public void AddParticleFront(Particle particle)
		{
			mEntityList.AddParticleFront(particle, particle.mLayer);
		}

		void CheckQuitInput()
		{
			if (IsKeyDown(.F11))
				mQuit = true;
		}
	//   -
		///*
		///*
		void HandleInputs()
		{
			mGameState.HandleInput();
		}

		public override void KeyDown(SDL.KeyboardEvent evt)
		{
			base.KeyDown(evt);
			if (evt.keysym.scancode == .P)
			{
				if (mPause)
				{
					mPause = false;
				} else
				{
					mPause = true;
				}
			}
			/*else if (evt.keysym.scancode == .T)
			{
				gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugTimeLogic, 1);
				gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugTimeDraw, 1);
			}
			else if (evt.keysym.scancode == .Y)
			{
				gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugTimeLogic, 0);
				gEngineApp.mGameRules.SetRange(Engine.GameRules.DebugTimeDraw, 0);
			}*/
			else if (evt.keysym.scancode == .F)
			{
				mFrameAdvance = true;
			}
			else if (evt.keysym.scancode == .G)
			{
				for (int i = 0; i < 10; i++)
				{
					float size = gRand.Next(5, 10);
					Particle p = new Particle(new Vector2D(mWidth / 2, mHeight / 2), new Size2D(size, size), .FG4);
					p.mMaxUpdates = (60 + (gRand.Next(40) - 20)) * 5;
					p.mColor.SetColor((.)gRand.Next(255), (.)gRand.Next(255), (.)gRand.Next(255));
					p.RenderImage();
					p.mVel = (float)(gRand.Next(2000)) / 1000;
					p.mAngle = gRand.Next(360);
					AddParticle(p);
				}
			}
		}


		public override void MouseDown(SDL.MouseButtonEvent evt)
		{
			base.MouseDown(evt);
			mGameState.MouseDown(evt);
		}

		public override void MouseUp(SDL.MouseButtonEvent evt)
		{
			base.MouseUp(evt);
			mGameState.MouseUp(evt);
		}

		public override void HandleEvent(SDL.Event evt)
		{
			base.HandleEvent(evt);
			switch (evt.type)
			{
			case .MouseMotion:
				mGameState.MouseMotion(evt);
			default:
				mGameState.HandleEvent(evt);
			}
		}

		void updateBase<T>(List<T> list, int dt) where T : BaseObject, delete
		{
#if DEBUG
			var logTime = gEngineApp.mGameRules.GetRangeAsBool(Engine.GameRules.DebugTimeLogic);
#endif
			for (var object in list)
			{
				object.mUpdateCnt++;
				if (!object.mIsDeleting)
				{
#if DEBUG
					String name = object.Name();
					if (logTime)
					{
						Timer.AddAndStart(name);
					}
#endif

					object.Update(dt);
#if DEBUG
					if (logTime)
					{
						Timer.Stop(name);
					}
#endif
				}
				else
				{
					if (++object.mDeletedFrames >= 3)
					{
						@object.Remove();
						delete object;
					}
				}
			}
		}

		public override void Update(int dt)
		{
			base.Update(dt);
			CheckQuitInput();// Check if F11 was Pressed even when the Game is paused.
			mFPSCounter.Update(dt);
			mCmd?.Update();


			if (!mPause || mFrameAdvance)
			{
				++mLogicCycleCounter;
				mFrameAdvance = false;

				HandleInputs();

				mGameState.Update(dt);
#if DEBUG
				var logTime = gEngineApp.mGameRules.GetRangeAsBool(Engine.GameRules.DebugTimeLogic);
				if(logTime)
					Timer.AddAndStart("FrameTimer");
#endif
				for (var layers in mEntityList.mLayers)
				{
#if DEBUG
					var timerid = StackStringFormat!("Layer{}", @layers.Index);
					if(logTime)
						Timer.AddAndStart(timerid);
#endif
					updateBase(layers.mEntities, dt);
					updateBase(layers.mParticles, dt);
#if DEBUG
					if(logTime)
						Timer.Stop(timerid);
#endif
				}
#if DEBUG
				if(logTime)
				{
					Timer.Stop("FrameTimer");
					Logger.LogMeta(System.Compiler.CallerFileName, System.Compiler.CallerLineNum, "Update");
					Logger.Log(StackStringFormat!("FrameCount: {}", mLogicCycleCounter));
					Timer.PrintAllTimer();
					Timer.Clear();
				}
#endif
			}
		}

		public override void Draw(int dt)
		{
			mGameState.Draw(dt);
		}

		public void SetTitle(String title)
		{
			SafeMemberSet!(mTitle, new String(title));
			SDL2.SDL.SetWindowTitle(mWindow, mTitle);
		}
	}
}
