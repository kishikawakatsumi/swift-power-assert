"use strict";

import { config, library, dom } from "@fortawesome/fontawesome-svg-core";
import {
  faPlay,
  faEraser,
  faAlignLeft,
  faCog,
  faQuestion,
  faCheckCircle as faCheckCircleSolid,
  faExclamationTriangle,
} from "@fortawesome/pro-solid-svg-icons";
import {
  faCheck,
  faCommentAltSmile,
  faCheckCircle,
  faAt,
  faDonate,
  faHeart,
} from "@fortawesome/pro-regular-svg-icons";
import { faMonitorHeartRate } from "@fortawesome/pro-light-svg-icons";
import { faSpinnerThird, faRobot } from "@fortawesome/pro-duotone-svg-icons";
import { faSwift, faGithub } from "@fortawesome/free-brands-svg-icons";

config.searchPseudoElements = true;
library.add(
  faPlay,
  faEraser,
  faAlignLeft,
  faCog,
  faQuestion,
  faCheckCircleSolid,
  faExclamationTriangle,

  faCheck,
  faCommentAltSmile,
  faCheckCircle,
  faAt,
  faDonate,
  faHeart,

  faMonitorHeartRate,

  faSpinnerThird,
  faRobot,

  faSwift,
  faGithub
);
dom.watch();
