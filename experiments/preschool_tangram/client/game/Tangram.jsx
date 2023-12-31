import { relativeTimeRounding } from "moment";
import React from "react";
import _ from "lodash";

const awwSound = new Audio("experiment/aww.mp3");
const wooSound = new Audio("experiment/woo.mp3");
const yaySound = new Audio("experiment/yay.mp3");

export default class Tangram extends React.Component {
    
  handleClick = e => {
    const { game, tangram, tangram_num, stage, player, round } = this.props;
    const speakerMsgs = _.filter(round.get("chat"), msg => {
      return msg.role == 'speaker'    })
    const speaker = _.find(game.players, p => p.get('role') === "speaker");
    const target=round.get("target")
    // only register click for listener and only after the speaker has sent a message
    if (stage.name == 'selection' &
        player.get('clicked') === false &
        player.get('role') == 'listener') {
      player.set("clicked", tangram)

      if (!round.get('submitted')){
        speaker.stage.submit()
        round.set('submitted', true)
      }
      //Meteor.setTimeout(()=> console.log(player.stage.submittedAt), 5)
      if (target==tangram) {round.get("sound")=="yay"?yaySound.play():wooSound.play()}
      else {awwSound.play()}
      player.stage.submit()
      //console.log(player.stage.submittedAt)


    }
  };

  render() {
    const { game, tangram, tangram_num, round, stage, player, ...rest } = this.props;
    const players = game.players
    const target = round.get("target")
    const row = 1 + Math.floor(tangram_num / 2)
    const column = 1 + tangram_num % 2
    const mystyle = {
      "background" : "url(" + tangram + ")",
      "backgroundSize" : "90%",
      "backgroundRepeat" : "no-repeat",
      "backgroundPosition" : "50% 50%",
      //"minWidth: 500px;
      //min-height: 500px;
      //padding: 100px;
      //border: 2px solid black;
      //outline: #4CAF50 solid 10px;
      //margin: auto;  
      //padding: 20px;
      //text-align: center;
      //cursor: pointer;
      "gridRow": row,
      "gridColumn": column
    };

    // Highlight target object for speaker 
    if(target == tangram & player.get('role') == 'speaker') {
      _.extend(mystyle, {
        "outline" :  "20px solid #000",
      })
    }

    if(target == tangram & stage.name=="feedback") {
      _.extend(mystyle, {
        "outline" :  "20px solid #000",
      })
    }

    // Show listeners what they've clicked 
    if(stage.name=="selection" & tangram == player.get('clicked')) {
      _.extend(mystyle, {
        "outline" :  `20px solid #A9A9A9`,
      })
    }

    // Highlight clicked object in green if correct; red if incorrect
    
    

  if (game.get("feedback")=="full"){ 
    if(stage.name=="feedback" & _.some(players, p => p.get("clicked") == tangram)) {
    const color = tangram == target ? 'green' : 'red';
    _.extend(mystyle, {
      "outline" :  `20px solid ${color}`,
    })
  }
  
}

    
    return (
      <div
        className="tangram"
        onClick={this.handleClick}
        style={mystyle}
        >
      </div>
    );
  }
}
