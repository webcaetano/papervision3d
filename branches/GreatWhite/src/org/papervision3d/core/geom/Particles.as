﻿package org.papervision3d.core.geom
{
	/**
	 * @Author Ralph Hauwert
	 */
	
	import org.papervision3d.core.geom.renderables.Particle;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class Particles extends Vertices3D
	{
		
		private var vertices:Array;
		public var particles:Array;
		
		/**
		 * VertexParticles
		 * 
		 * A simple Particle Renderer for Papervision3D.
		 * 
		 * Renders added particles to a given container using Flash's drawing API.
		 */
		public function Particles(name:String = "VertexParticles")
		{
			this.vertices = new Array();
			this.particles = new Array();
			super(vertices, name);
		}
		
		/**
		 * Project
		 */
		public override function project( parent :DisplayObject3D, renderSessionData:RenderSessionData ):Number
		{
			super.project(parent,renderSessionData);
			var p:Particle;
			var fz:Number = (renderSessionData.camera.focus*renderSessionData.camera.zoom);
			for each(p in particles){
				if(renderSessionData.viewPort.particleCuller.testParticle(p)){
					p.renderScale = fz / (renderSessionData.camera.focus + p.vertex3D.vertex3DInstance.z);
					p.renderCommand.screenDepth = p.vertex3D.vertex3DInstance.z;
					renderSessionData.renderer.addToRenderList(p.renderCommand);	
				}else{
					renderSessionData.renderStatistics.culledParticles++;
				}
			}
			return 1;
		}
		
		/**
		 * addParticle(particle);
		 * 
		 * @param	particle	partical to be added and rendered by to this VertexParticles Object.
		 */
		public function addParticle(particle:Particle):void
		{
			particle.instance = this;
			particles.push(particle);
			vertices.push(particle.vertex3D);
		}
		
		/**
		 * removeParticle(particle);
		 * 
		 * @param	particle	partical to be removed from this VertexParticles Object.
		 */
		public function removeParticle(particle:Particle):void
		{
			particle.instance = null;
			particles.splice(particles.indexOf(particle,0));
			vertices.splice(vertices.indexOf(particle.vertex3D,0));
		}
		
		/**
		 * removeAllParticles()
		 * 
		 * removes all particles in this VertexParticles Object.
		 */
		public function removeAllParticles():void
		{
			particles = new Array();
			vertices = new Array();
			geometry.vertices = vertices;
		}
		
		
	}
}