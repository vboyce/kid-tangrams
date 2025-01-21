import React from "react";
import { Breadcrumb as Crumb, Classes } from "@blueprintjs/core";

export default class customBreadcrumb extends React.Component {
  render() {
    const { game, round, stage } = this.props;
    return (
      <nav className="round-nav">
      </nav>
    );
  }
}
