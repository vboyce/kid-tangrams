import React from "react";

import Tangram from "./Tangram.jsx";


const awwSound = new Audio("experiment/aww.mp3");
const wooSound = new Audio("experiment/woo.mp3");
const yaySound = new Audio("experiment/yay.mp3");
export default class Task extends React.Component {
  constructor(props) {
    super(props);

    // We want each participant to see tangrams in a random but stable order
    // so we shuffle at the beginning and save in state
    this.state = {
      activeButton: false
    };
    const {stage, round, player}= this.props;
    const target = round.get("target");
    if (stage.name=="feedback"){
      if (player.get('role')=='speaker'){
        if (round.get("countCorrect")==(round.get("activePlayerCount")-1)){
          round.get("sound")=="yay"? yaySound.play(): wooSound.play()
        }
        else
        {awwSound.play()}
      }
      else if (player.get("clicked")==target){
        round.get("sound")=="yay"? yaySound.play(): wooSound.play()      }
      else {awwSound.play()}

      }
  }

  render() {
    const { game, round, stage, player } = this.props;
    const target = round.get("target");
    const tangramURLs =  player.get('tangramURLs');
    const correct = player.get('clicked') == target
    let tangramsToRender;
    if (tangramURLs) {
      tangramsToRender = tangramURLs.map((tangram, i) => (
        <Tangram
          key={tangram}
          tangram={tangram}
          tangram_num={i}
          round={round}
          stage={stage}
          game={game}
          player={player}
          />
      ));
    }
      
    let feedback = ""
    if (stage.name=="feedback"){
      if (player.get('role')=='speaker'){
        if (round.get("countCorrect")==(round.get("activePlayerCount")-1)){
          feedback='/experiment/yay.jpg'
        }
        else
        {feedback='/experiment/aww.jpeg'}
      }
      else if (player.get("clicked")==target){
        feedback='/experiment/yay.jpg'     }
      else {feedback='/experiment/aww.jpeg'}

      }
    
    return (
      <div className="task">
        <div className="board">
          <div className="roleIndicator">
          <img src={feedback}/>
          </div>
          <div className="all-tangrams">
            <div className="tangrams">
              {tangramsToRender}
            </div>
          </div>
        </div>
      </div>
    );
  }
}
