using System.Collections;
using BasicEngine;
using BasicEngine.Particle;
using BasicEngine.Entity;

namespace BasicEngine.LayeredList
{
	class LayeredItem
	{
		public List<Entity> mEntities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		public List<Particle> mParticles = new List<Particle>() ~ DeleteContainerAndItems!(_);
	}

	class LayeredList
	{
		public List<LayeredItem> mLayers ~ DeleteContainerAndItems!(_);
		private int maxLayer = 0;
		public enum LayerNames : uint8 {
			BG1 = 0,
			BG2 = 1,
			BG3 = 2,
			BG4 = 3,
			MainLayer = 4,
			FG1 = 5,
			FG2 = 6,
			FG3 = 7,
			FG4 = 8,
			HUD = 9,
		}

		public this(int layers)
		{
			maxLayer = layers;
			mLayers = new List<LayeredItem>(maxLayer);
			for(int i < maxLayer)
				mLayers.Add(new LayeredItem());
		}

		public void AddEntity(Entity entity, LayerNames layer = 0)
		{
			if((uint8)layer > maxLayer)
				return;
			mLayers[(uint8)layer].mEntities.Add(entity);
		}

		public void AddEntityFront(Entity entity, LayerNames layer = 0)
		{
			if((uint8)layer > maxLayer)
				return;
			mLayers[(uint8)layer].mEntities.Insert(0, entity);
		}

		public void AddParticle(Particle particle, LayerNames layer = 0)
		{
			if((uint8)layer > maxLayer)
				return;
			mLayers[(uint8)layer].mParticles.Add(particle);
		}

		public void AddParticleFront(Particle particle, LayerNames layer = 0)
		{
			if((uint8)layer > maxLayer)
				return;
			mLayers[(uint8)layer].mParticles.Insert(0, particle);
		}

		public List<Entity> GetAllEntities()
		{
			List<Entity> ret = new List<Entity>();
			for(let e in mLayers)
				ret.AddRange(e.mEntities);
			return ret;
		}

		public List<Particle> GetAllParticles()
		{
			List<Particle> ret = new List<Particle>();
			for(let p in mLayers)
				ret.AddRange(p.mParticles);
			return ret;
		}
	}
}
