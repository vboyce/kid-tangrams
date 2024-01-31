import React from "react";

import { Centered } from "meteor/empirica:core";
import { Button } from "@blueprintjs/core";
const roundSound = new Audio("experiment/round-sound.mp3");

export default class Pause extends React.Component {
    constructor(props) {
        super(props);
        const{onNext} = this.props;
        
        setTimeout(function() {
            onNext()
        }, 30000);
      }
  render() {

        const mystyle = {
          "background" : "url(" + "experiment/end.jpeg" + ")",
          "backgroundSize" : "100%",
          "backgroundRepeat" : "no-repeat",
          "backgroundPosition" : "50% 50%",
          "height": "500px"
        }
        
        return (
          <Centered>
            <div className="game finished" style={mystyle} >
              <hr />
            </div>
          </Centered>
        );
      }
}
