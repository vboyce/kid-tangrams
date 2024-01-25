import React from "react";

import { Centered } from "meteor/empirica:core";
import { Button } from "@blueprintjs/core";

import Bubble from "./bubble.jsx";

const roundSound = new Audio("experiment/round-sound.mp3");


  
export default class Smileys extends React.Component {

  constructor(props) {
    super(props);

    // We want each participant to see tangrams in a random but stable order
    // so we shuffle at the beginning and save in state

    
    this.state = {
      count: 0
    }
    this.dotCount=5;
    this.dotType="smiley";
    let i;
    let dotx=[];
    let doty=[];

    function createDot(dotx, doty){
        var x = Math.floor(Math.random()*950);
        var y = Math.floor(Math.random()*540);
      
        var invalid = "true";
      
          //make sure dots do not overlap
          while (true) {
            invalid = "true";
            let j;
             for (j = 0; j < dotx.length ; j++) {
              if (Math.abs(dotx[j] - x) + Math.abs(doty[j] - y) < 250) {
                var invalid = "false";
                break; 
              }
          }
          if (invalid === "true") {
             dotx.push(x);
                doty.push(y);
                break;	
             }
             x = Math.floor(Math.random()*400);
             y = Math.floor(Math.random()*400);
        }
      }

      for (i = 0; i < this.dotCount; i++) {
          createDot(dotx, doty);
      }
 
    this.bubbleInfo=[];
    dotx.forEach((x,i)=>this.bubbleInfo.push({x:x,y:doty[i],i:i+1}))
  }


  
    render() {
    const { onNext } = this.props;

    let allBubbles;
    const check_all_popped= ()=>{if(this.state.count==this.dotCount){
        setTimeout(function() {
            onNext()
        }, 1000);
    }};
    const popped = ()=>{this.setState({count:this.state.count+1}, check_all_popped)};
    allBubbles=this.bubbleInfo.map(bubble => (
        <Bubble
        key={bubble.i}
        onNext={onNext}
        popped={popped}
        tag={this.dotType}
        dotx={bubble.x}
        doty={bubble.y}
        i={bubble.i}
            />
    ));

    function finish(){
      onNext()
    }
    return (
      <Centered>
        <div className="instructions">
        {allBubbles}
        </div>
      </Centered>
    );
  }
}
