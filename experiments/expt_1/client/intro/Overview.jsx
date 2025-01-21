import React from "react";

import { Centered } from "meteor/empirica:core";
import { Button } from "@blueprintjs/core";
const roundSound = new Audio("experiment/round-sound.mp3");

export default class Overview extends React.Component {
  render() {
    const { hasPrev, hasNext, onNext, onPrev, treatment } = this.props;
    function finish(){
      roundSound.play()
      onNext()
    }
    return (
      <Centered>
        <div className="instructions">
       
          <button
            type="button"
            className="bp3-button bp3-intent-primary"
            onClick={onNext}
          >
            
            <span className="bp3-icon-standard bp3-icon-double-chevron-right bp3-align-right"/>
          </button>
        </div>
      </Centered>
    );
  }
}
