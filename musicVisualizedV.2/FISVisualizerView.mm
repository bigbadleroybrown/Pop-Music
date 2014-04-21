//
//  FISVisualizerView.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 3/14/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "FISVisualizerView.h"
#import <QuartzCore/QuartzCore.h>
#import "MeterTable.h"
#import <AVFoundation/AVFoundation.h>
#import "UIEffectDesignerView.h"
#import "ViewController.h"


@implementation FISVisualizerView

{
    CAEmitterLayer *emitterLayer;//instance variable to hold CAEmitterLayer
    MeterTable meterTable;
}

+ (Class)layerClass
{
    return [CAEmitterLayer class];//overides the default layer class to allow this view to act as a particle emitter
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor: [UIColor blackColor]];
        emitterLayer = (CAEmitterLayer *)self.layer;
        
        
        CGFloat width = MAX(frame.size.width, frame.size.height);
        CGFloat height = MIN(frame.size.width, frame.size.height);
        emitterLayer.emitterPosition = CGPointMake(width, height); //(width/2, height/2.0);
        
        emitterLayer.emitterSize = CGSizeMake(width=1000, 50.0); //originally -80, 60  need to figure out how to set size to bounds of screen
        emitterLayer.emitterShape = kCAEmitterLayerLine;
        emitterLayer.renderMode = kCAEmitterLayerAdditive; //orginally had as additive
        
        
        
        self.cell = [CAEmitterCell emitterCell];
        self.cell.name = @"cell";
        CAEmitterCell *childCell = [CAEmitterCell emitterCell]; //results in particles emitting paticles
        childCell.name = @"childCell";
        childCell.lifetime = 1.0f / 60.0f; //childCell particles have a lifetime of 1/60 seconds; the same length as a screen refresh while parents cells last for .75-1.25 seconds
        childCell.birthRate = 60.0f; //number of particles emitted per second
        
        
        
        childCell.velocity = 1.0f; //particles velocity in points per second
        childCell.contents = (id) [[UIImage imageNamed:@"hd2.png"] CGImage];
        self.cell.emitterCells = @[childCell];
        
        //sets the particle color, along with a range by which each of the red, green, and blue color components may vary.
        
        self.cell.color = [[UIColor colorWithRed:0.45f green:0.53f blue:0.77f alpha:0.8f] CGColor];
        self.cell.redRange = 0.46f;
        self.cell.greenRange = 0.49f;
        self.cell.blueRange = 0.67f;
        self.cell.alphaRange = 0.55f;
        
        //sets the scale and the amount by which the scale can vary for the generated particles.
        
        self.cell.scale = 1.0f; //.2 size of particles
        self.cell.scaleRange = 0.2f;
        
        //sets the amount of time each parent particle will exist to between .75 and 1.25 seconds
        
        self.cell.lifetime = 1.0f;
        self.cell.lifetimeRange = .25f;
        self.cell.birthRate = 100; //should actually be proportional to screen size
        
        //configures the emitter to create particles with a variable velocity, and to emit them in any direction.
        
        self.cell.velocity = 100.0f;
        self.cell.velocityRange = 300.0f;
        self.cell.emissionRange = M_PI *2;
        
        //add emmitter cell to the emitter layer
        emitterLayer.emitterCells = @[self.cell];
        
        CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)]; //update particle method from below is called here. A CADisplayLink is a timer that allows application to synchronize its drawing to the refresh rate of the display. That is it’s guaranteed to be called each time the device prepares to redraw the screen, which is at a rate of 60 times per second.
        
        
        [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];//The second line calls addToRunLoop:forMode:, which starts the display link timer.
        
    }
    return self;
}

-(void)update

{
    
    //scale set to a default value of 0.5 and check to see whether or not _audioPlayer is playing.
    float scale = 0.1;
    if (_audioPlayer.playing) {
        
        //If it is playing call updateMeters on _audioPlayer, which refreshes the AVAudioPlayer data based on the current audio.
        [_audioPlayer updateMeters];
        
        //For each audio channel the average power for that channel is added to power. The average power is a decibel value. After the powers of all the channels have been added together, power is divided by the number of channels. This means power now holds the average power, or decibel level, for all of the audio.
        
        float power = 0.0f;
        for (int i = 0; i < [_audioPlayer numberOfChannels]; i++) {
            power += [_audioPlayer averagePowerForChannel:i];
            
        }
        
        power /= [_audioPlayer numberOfChannels];
        
        //Here you pass the calculated average power value to meterTable‘s ValueAt method. It returns a value from 0 to 1, Multiplying by 5 accentuates the musics effect on the scale.
        
        //This is the most important part. As the level value is decreased the, the musics effect on the scale also falls.
        
        float level = meterTable.ValueAt(power);
        scale = level *2;
    }
    
    //scale of the emitter’s particles is set to the new scale value. (If _audioPlayer was not playing, this will be the default scale of 0.5; otherwise, it will be some value based on the current audio levels.
    
    [emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.emitterCells.childCell.scale"];
    
    //Particles are created and destroyed at the same rate as a screen refresh. That means that every time the screen is redrawn, a new set of particles is created and the previous set is destroyed. Since new particles are always created with a size calculated from the audio-levels at that moment, the particles appear to pulse with the music.
}


@end

