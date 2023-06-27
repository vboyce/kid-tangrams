import React from "react";
import {  AlertToaster } from "meteor/empirica:core";

import SocialInteractions from "./SocialInteractions.jsx";
import Task from "./Task.jsx";

const roundSound = new Audio("experiment/round-sound.mp3");
const gameSound = new Audio("experiment/bell.mp3");

export default class Round extends React.Component {
  componentDidMount() {
    const { game, player } = this.props;
  }

  render() {
    const {round, stage, player, game } = this.props;
    return (
      <div className="round">
        <Task game={game} round={round} stage={stage} player={player} />
      </div>
    );
  }
}
