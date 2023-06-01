"use strict";

import { config, library, dom } from "@fortawesome/fontawesome-svg-core";
import {
  faPlay,
  faEraser,
  faAlignLeft,
  faCog,
  faExclamationTriangle,
  faHeart,
} from "@fortawesome/pro-solid-svg-icons";
import {
  faToolbox,
  faCommentAltSmile,
  faAt,
} from "@fortawesome/pro-regular-svg-icons";
import { faSpinnerThird } from "@fortawesome/pro-duotone-svg-icons";
import { faSwift, faGithub } from "@fortawesome/free-brands-svg-icons";

config.searchPseudoElements = true;
library.add(
  faPlay,
  faEraser,
  faAlignLeft,
  faCog,
  faExclamationTriangle,
  faHeart,

  faToolbox,
  faCommentAltSmile,
  faAt,

  faSpinnerThird,

  faSwift,
  faGithub
);
dom.watch();
