import React from "react";

import { Centered } from "meteor/empirica:core";
import { Button } from "@blueprintjs/core";
const bubbleSound = new Audio("experiment/short_bubble.mp3");

export default class Bubble extends React.Component {
    constructor(props) {
        super(props);
    
        // We want each participant to see tangrams in a random but stable order
        // so we shuffle at the beginning and save in state
    
        
        this.state = {
          unclicked: true
        };
        
      }
    handleClick = e => {
      const {onNext, popped} = this.props;
      if (this.state.unclicked){
        bubbleSound.play()
        popped()
        this.setState({unclicked:false})
      } 
      }
  
    render() {
      const {tag, dotx, doty, i, unclicked} = this.props;
      let myimage;
    if (tag === "smiley") {
        myimage = "experiment/dots/dot_" + "smiley" + ".jpg";
    } else {
        myimage = "experiment/dots/dot_" + i + ".jpg";
    }
      const mystyle = {
        "position" : "absolute",
        "left": dotx+"px",
        "top": doty+"px"
      };
      
      if (this.state.unclicked===false) {myimage="experiment/dots/x.jpg"}  
  
      
      return (
        <img
          className="bubble"
          src={myimage}
          onClick={this.handleClick}
          style={mystyle}
          />
      );
    }
  }

