"use strict";

import { config, library, dom } from "@fortawesome/fontawesome-svg-core";
import {
  faPlay,
  faEraser,
  faAlignLeft,
  faCog,
  faExclamationTriangle,
} from "@fortawesome/pro-solid-svg-icons";
import {
  faToolbox,
  faCommentAltSmile,
  faAt,
  faDonate,
  faHeart,
} from "@fortawesome/pro-regular-svg-icons";
import { faMonitorHeartRate } from "@fortawesome/pro-light-svg-icons";
import { faSpinnerThird } from "@fortawesome/pro-duotone-svg-icons";
import { faSwift, faGithub } from "@fortawesome/free-brands-svg-icons";

config.searchPseudoElements = true;
library.add(
  faPlay,
  faEraser,
  faAlignLeft,
  faCog,
  faExclamationTriangle,

  faToolbox,
  faCommentAltSmile,
  faAt,
  faDonate,
  faHeart,

  faMonitorHeartRate,

  faSpinnerThird,

  faSwift,
  faGithub
);
dom.watch();
