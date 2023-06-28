import React from "react";

import {Centered} from "meteor/empirica:core";

const endSound = new Audio("end.mp3");

export default class Thanks extends React.Component {
  static stepName = "Thanks";

  componentWillMount() {}



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
