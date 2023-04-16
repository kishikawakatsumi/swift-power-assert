import Foundation

func codePointWidth(_ scalar: UnicodeScalar) -> Int {
  if (0...31).contains(scalar.value) {
    return 0
  }
  if (127...159).contains(scalar.value) {
    return 0
  }
  if (768...879).contains(scalar.value) {
    return 0
  }
  if (1155...1159).contains(scalar.value) {
    return 0
  }
  if (1160...1161).contains(scalar.value) {
    return 0
  }
  if (1425...1469).contains(scalar.value) {
    return 0
  }
  if (1471...1471).contains(scalar.value) {
    return 0
  }
  if (1473...1474).contains(scalar.value) {
    return 0
  }
  if (1476...1477).contains(scalar.value) {
    return 0
  }
  if (1479...1479).contains(scalar.value) {
    return 0
  }
  if (1552...1562).contains(scalar.value) {
    return 0
  }
  if (1611...1631).contains(scalar.value) {
    return 0
  }
  if (1648...1648).contains(scalar.value) {
    return 0
  }
  if (1750...1756).contains(scalar.value) {
    return 0
  }
  if (1759...1764).contains(scalar.value) {
    return 0
  }
  if (1767...1768).contains(scalar.value) {
    return 0
  }
  if (1770...1773).contains(scalar.value) {
    return 0
  }
  if (1809...1809).contains(scalar.value) {
    return 0
  }
  if (1840...1866).contains(scalar.value) {
    return 0
  }
  if (1958...1968).contains(scalar.value) {
    return 0
  }
  if (2027...2035).contains(scalar.value) {
    return 0
  }
  if (2045...2045).contains(scalar.value) {
    return 0
  }
  if (2070...2073).contains(scalar.value) {
    return 0
  }
  if (2075...2083).contains(scalar.value) {
    return 0
  }
  if (2085...2087).contains(scalar.value) {
    return 0
  }
  if (2089...2093).contains(scalar.value) {
    return 0
  }
  if (2137...2139).contains(scalar.value) {
    return 0
  }
  if (2200...2207).contains(scalar.value) {
    return 0
  }
  if (2250...2273).contains(scalar.value) {
    return 0
  }
  if (2275...2306).contains(scalar.value) {
    return 0
  }
  if (2362...2362).contains(scalar.value) {
    return 0
  }
  if (2364...2364).contains(scalar.value) {
    return 0
  }
  if (2369...2376).contains(scalar.value) {
    return 0
  }
  if (2381...2381).contains(scalar.value) {
    return 0
  }
  if (2385...2391).contains(scalar.value) {
    return 0
  }
  if (2402...2403).contains(scalar.value) {
    return 0
  }
  if (2433...2433).contains(scalar.value) {
    return 0
  }
  if (2492...2492).contains(scalar.value) {
    return 0
  }
  if (2497...2500).contains(scalar.value) {
    return 0
  }
  if (2509...2509).contains(scalar.value) {
    return 0
  }
  if (2530...2531).contains(scalar.value) {
    return 0
  }
  if (2558...2558).contains(scalar.value) {
    return 0
  }
  if (2561...2562).contains(scalar.value) {
    return 0
  }
  if (2620...2620).contains(scalar.value) {
    return 0
  }
  if (2625...2626).contains(scalar.value) {
    return 0
  }
  if (2631...2632).contains(scalar.value) {
    return 0
  }
  if (2635...2637).contains(scalar.value) {
    return 0
  }
  if (2641...2641).contains(scalar.value) {
    return 0
  }
  if (2672...2673).contains(scalar.value) {
    return 0
  }
  if (2677...2677).contains(scalar.value) {
    return 0
  }
  if (2689...2690).contains(scalar.value) {
    return 0
  }
  if (2748...2748).contains(scalar.value) {
    return 0
  }
  if (2753...2757).contains(scalar.value) {
    return 0
  }
  if (2759...2760).contains(scalar.value) {
    return 0
  }
  if (2765...2765).contains(scalar.value) {
    return 0
  }
  if (2786...2787).contains(scalar.value) {
    return 0
  }
  if (2810...2815).contains(scalar.value) {
    return 0
  }
  if (2817...2817).contains(scalar.value) {
    return 0
  }
  if (2876...2876).contains(scalar.value) {
    return 0
  }
  if (2879...2879).contains(scalar.value) {
    return 0
  }
  if (2881...2884).contains(scalar.value) {
    return 0
  }
  if (2893...2893).contains(scalar.value) {
    return 0
  }
  if (2901...2902).contains(scalar.value) {
    return 0
  }
  if (2914...2915).contains(scalar.value) {
    return 0
  }
  if (2946...2946).contains(scalar.value) {
    return 0
  }
  if (3008...3008).contains(scalar.value) {
    return 0
  }
  if (3021...3021).contains(scalar.value) {
    return 0
  }
  if (3072...3072).contains(scalar.value) {
    return 0
  }
  if (3076...3076).contains(scalar.value) {
    return 0
  }
  if (3132...3132).contains(scalar.value) {
    return 0
  }
  if (3134...3136).contains(scalar.value) {
    return 0
  }
  if (3142...3144).contains(scalar.value) {
    return 0
  }
  if (3146...3149).contains(scalar.value) {
    return 0
  }
  if (3157...3158).contains(scalar.value) {
    return 0
  }
  if (3170...3171).contains(scalar.value) {
    return 0
  }
  if (3201...3201).contains(scalar.value) {
    return 0
  }
  if (3260...3260).contains(scalar.value) {
    return 0
  }
  if (3263...3263).contains(scalar.value) {
    return 0
  }
  if (3270...3270).contains(scalar.value) {
    return 0
  }
  if (3276...3277).contains(scalar.value) {
    return 0
  }
  if (3298...3299).contains(scalar.value) {
    return 0
  }
  if (3328...3329).contains(scalar.value) {
    return 0
  }
  if (3387...3388).contains(scalar.value) {
    return 0
  }
  if (3393...3396).contains(scalar.value) {
    return 0
  }
  if (3405...3405).contains(scalar.value) {
    return 0
  }
  if (3426...3427).contains(scalar.value) {
    return 0
  }
  if (3457...3457).contains(scalar.value) {
    return 0
  }
  if (3530...3530).contains(scalar.value) {
    return 0
  }
  if (3538...3540).contains(scalar.value) {
    return 0
  }
  if (3542...3542).contains(scalar.value) {
    return 0
  }
  if (3633...3633).contains(scalar.value) {
    return 0
  }
  if (3636...3642).contains(scalar.value) {
    return 0
  }
  if (3655...3662).contains(scalar.value) {
    return 0
  }
  if (3761...3761).contains(scalar.value) {
    return 0
  }
  if (3764...3772).contains(scalar.value) {
    return 0
  }
  if (3784...3790).contains(scalar.value) {
    return 0
  }
  if (3864...3865).contains(scalar.value) {
    return 0
  }
  if (3893...3893).contains(scalar.value) {
    return 0
  }
  if (3895...3895).contains(scalar.value) {
    return 0
  }
  if (3897...3897).contains(scalar.value) {
    return 0
  }
  if (3953...3966).contains(scalar.value) {
    return 0
  }
  if (3968...3972).contains(scalar.value) {
    return 0
  }
  if (3974...3975).contains(scalar.value) {
    return 0
  }
  if (3981...3991).contains(scalar.value) {
    return 0
  }
  if (3993...4028).contains(scalar.value) {
    return 0
  }
  if (4038...4038).contains(scalar.value) {
    return 0
  }
  if (4141...4144).contains(scalar.value) {
    return 0
  }
  if (4146...4151).contains(scalar.value) {
    return 0
  }
  if (4153...4154).contains(scalar.value) {
    return 0
  }
  if (4157...4158).contains(scalar.value) {
    return 0
  }
  if (4184...4185).contains(scalar.value) {
    return 0
  }
  if (4190...4192).contains(scalar.value) {
    return 0
  }
  if (4209...4212).contains(scalar.value) {
    return 0
  }
  if (4226...4226).contains(scalar.value) {
    return 0
  }
  if (4229...4230).contains(scalar.value) {
    return 0
  }
  if (4237...4237).contains(scalar.value) {
    return 0
  }
  if (4253...4253).contains(scalar.value) {
    return 0
  }
  if (4957...4959).contains(scalar.value) {
    return 0
  }
  if (5906...5908).contains(scalar.value) {
    return 0
  }
  if (5938...5939).contains(scalar.value) {
    return 0
  }
  if (5970...5971).contains(scalar.value) {
    return 0
  }
  if (6002...6003).contains(scalar.value) {
    return 0
  }
  if (6068...6069).contains(scalar.value) {
    return 0
  }
  if (6071...6077).contains(scalar.value) {
    return 0
  }
  if (6086...6086).contains(scalar.value) {
    return 0
  }
  if (6089...6099).contains(scalar.value) {
    return 0
  }
  if (6109...6109).contains(scalar.value) {
    return 0
  }
  if (6155...6157).contains(scalar.value) {
    return 0
  }
  if (6159...6159).contains(scalar.value) {
    return 0
  }
  if (6277...6278).contains(scalar.value) {
    return 0
  }
  if (6313...6313).contains(scalar.value) {
    return 0
  }
  if (6432...6434).contains(scalar.value) {
    return 0
  }
  if (6439...6440).contains(scalar.value) {
    return 0
  }
  if (6450...6450).contains(scalar.value) {
    return 0
  }
  if (6457...6459).contains(scalar.value) {
    return 0
  }
  if (6679...6680).contains(scalar.value) {
    return 0
  }
  if (6683...6683).contains(scalar.value) {
    return 0
  }
  if (6742...6742).contains(scalar.value) {
    return 0
  }
  if (6744...6750).contains(scalar.value) {
    return 0
  }
  if (6752...6752).contains(scalar.value) {
    return 0
  }
  if (6754...6754).contains(scalar.value) {
    return 0
  }
  if (6757...6764).contains(scalar.value) {
    return 0
  }
  if (6771...6780).contains(scalar.value) {
    return 0
  }
  if (6783...6783).contains(scalar.value) {
    return 0
  }
  if (6832...6845).contains(scalar.value) {
    return 0
  }
  if (6846...6846).contains(scalar.value) {
    return 0
  }
  if (6847...6862).contains(scalar.value) {
    return 0
  }
  if (6912...6915).contains(scalar.value) {
    return 0
  }
  if (6964...6964).contains(scalar.value) {
    return 0
  }
  if (6966...6970).contains(scalar.value) {
    return 0
  }
  if (6972...6972).contains(scalar.value) {
    return 0
  }
  if (6978...6978).contains(scalar.value) {
    return 0
  }
  if (7019...7027).contains(scalar.value) {
    return 0
  }
  if (7040...7041).contains(scalar.value) {
    return 0
  }
  if (7074...7077).contains(scalar.value) {
    return 0
  }
  if (7080...7081).contains(scalar.value) {
    return 0
  }
  if (7083...7085).contains(scalar.value) {
    return 0
  }
  if (7142...7142).contains(scalar.value) {
    return 0
  }
  if (7144...7145).contains(scalar.value) {
    return 0
  }
  if (7149...7149).contains(scalar.value) {
    return 0
  }
  if (7151...7153).contains(scalar.value) {
    return 0
  }
  if (7212...7219).contains(scalar.value) {
    return 0
  }
  if (7222...7223).contains(scalar.value) {
    return 0
  }
  if (7376...7378).contains(scalar.value) {
    return 0
  }
  if (7380...7392).contains(scalar.value) {
    return 0
  }
  if (7394...7400).contains(scalar.value) {
    return 0
  }
  if (7405...7405).contains(scalar.value) {
    return 0
  }
  if (7412...7412).contains(scalar.value) {
    return 0
  }
  if (7416...7417).contains(scalar.value) {
    return 0
  }
  if (7616...7679).contains(scalar.value) {
    return 0
  }
  if (8400...8412).contains(scalar.value) {
    return 0
  }
  if (8413...8416).contains(scalar.value) {
    return 0
  }
  if (8417...8417).contains(scalar.value) {
    return 0
  }
  if (8418...8420).contains(scalar.value) {
    return 0
  }
  if (8421...8432).contains(scalar.value) {
    return 0
  }
  if (11503...11505).contains(scalar.value) {
    return 0
  }
  if (11647...11647).contains(scalar.value) {
    return 0
  }
  if (11744...11775).contains(scalar.value) {
    return 0
  }
  if (12330...12333).contains(scalar.value) {
    return 0
  }
  if (12441...12442).contains(scalar.value) {
    return 0
  }
  if (42607...42607).contains(scalar.value) {
    return 0
  }
  if (42608...42610).contains(scalar.value) {
    return 0
  }
  if (42612...42621).contains(scalar.value) {
    return 0
  }
  if (42654...42655).contains(scalar.value) {
    return 0
  }
  if (42736...42737).contains(scalar.value) {
    return 0
  }
  if (43010...43010).contains(scalar.value) {
    return 0
  }
  if (43014...43014).contains(scalar.value) {
    return 0
  }
  if (43019...43019).contains(scalar.value) {
    return 0
  }
  if (43045...43046).contains(scalar.value) {
    return 0
  }
  if (43052...43052).contains(scalar.value) {
    return 0
  }
  if (43204...43205).contains(scalar.value) {
    return 0
  }
  if (43232...43249).contains(scalar.value) {
    return 0
  }
  if (43263...43263).contains(scalar.value) {
    return 0
  }
  if (43302...43309).contains(scalar.value) {
    return 0
  }
  if (43335...43345).contains(scalar.value) {
    return 0
  }
  if (43392...43394).contains(scalar.value) {
    return 0
  }
  if (43443...43443).contains(scalar.value) {
    return 0
  }
  if (43446...43449).contains(scalar.value) {
    return 0
  }
  if (43452...43453).contains(scalar.value) {
    return 0
  }
  if (43493...43493).contains(scalar.value) {
    return 0
  }
  if (43561...43566).contains(scalar.value) {
    return 0
  }
  if (43569...43570).contains(scalar.value) {
    return 0
  }
  if (43573...43574).contains(scalar.value) {
    return 0
  }
  if (43587...43587).contains(scalar.value) {
    return 0
  }
  if (43596...43596).contains(scalar.value) {
    return 0
  }
  if (43644...43644).contains(scalar.value) {
    return 0
  }
  if (43696...43696).contains(scalar.value) {
    return 0
  }
  if (43698...43700).contains(scalar.value) {
    return 0
  }
  if (43703...43704).contains(scalar.value) {
    return 0
  }
  if (43710...43711).contains(scalar.value) {
    return 0
  }
  if (43713...43713).contains(scalar.value) {
    return 0
  }
  if (43756...43757).contains(scalar.value) {
    return 0
  }
  if (43766...43766).contains(scalar.value) {
    return 0
  }
  if (44005...44005).contains(scalar.value) {
    return 0
  }
  if (44008...44008).contains(scalar.value) {
    return 0
  }
  if (44013...44013).contains(scalar.value) {
    return 0
  }
  if (64286...64286).contains(scalar.value) {
    return 0
  }
  if (65024...65039).contains(scalar.value) {
    return 0
  }
  if (65056...65071).contains(scalar.value) {
    return 0
  }
  if (66045...66045).contains(scalar.value) {
    return 0
  }
  if (66272...66272).contains(scalar.value) {
    return 0
  }
  if (66422...66426).contains(scalar.value) {
    return 0
  }
  if (68097...68099).contains(scalar.value) {
    return 0
  }
  if (68101...68102).contains(scalar.value) {
    return 0
  }
  if (68108...68111).contains(scalar.value) {
    return 0
  }
  if (68152...68154).contains(scalar.value) {
    return 0
  }
  if (68159...68159).contains(scalar.value) {
    return 0
  }
  if (68325...68326).contains(scalar.value) {
    return 0
  }
  if (68900...68903).contains(scalar.value) {
    return 0
  }
  if (69291...69292).contains(scalar.value) {
    return 0
  }
  if (69373...69375).contains(scalar.value) {
    return 0
  }
  if (69446...69456).contains(scalar.value) {
    return 0
  }
  if (69506...69509).contains(scalar.value) {
    return 0
  }
  if (69633...69633).contains(scalar.value) {
    return 0
  }
  if (69688...69702).contains(scalar.value) {
    return 0
  }
  if (69744...69744).contains(scalar.value) {
    return 0
  }
  if (69747...69748).contains(scalar.value) {
    return 0
  }
  if (69759...69761).contains(scalar.value) {
    return 0
  }
  if (69811...69814).contains(scalar.value) {
    return 0
  }
  if (69817...69818).contains(scalar.value) {
    return 0
  }
  if (69826...69826).contains(scalar.value) {
    return 0
  }
  if (69888...69890).contains(scalar.value) {
    return 0
  }
  if (69927...69931).contains(scalar.value) {
    return 0
  }
  if (69933...69940).contains(scalar.value) {
    return 0
  }
  if (70003...70003).contains(scalar.value) {
    return 0
  }
  if (70016...70017).contains(scalar.value) {
    return 0
  }
  if (70070...70078).contains(scalar.value) {
    return 0
  }
  if (70089...70092).contains(scalar.value) {
    return 0
  }
  if (70095...70095).contains(scalar.value) {
    return 0
  }
  if (70191...70193).contains(scalar.value) {
    return 0
  }
  if (70196...70196).contains(scalar.value) {
    return 0
  }
  if (70198...70199).contains(scalar.value) {
    return 0
  }
  if (70206...70206).contains(scalar.value) {
    return 0
  }
  if (70209...70209).contains(scalar.value) {
    return 0
  }
  if (70367...70367).contains(scalar.value) {
    return 0
  }
  if (70371...70378).contains(scalar.value) {
    return 0
  }
  if (70400...70401).contains(scalar.value) {
    return 0
  }
  if (70459...70460).contains(scalar.value) {
    return 0
  }
  if (70464...70464).contains(scalar.value) {
    return 0
  }
  if (70502...70508).contains(scalar.value) {
    return 0
  }
  if (70512...70516).contains(scalar.value) {
    return 0
  }
  if (70712...70719).contains(scalar.value) {
    return 0
  }
  if (70722...70724).contains(scalar.value) {
    return 0
  }
  if (70726...70726).contains(scalar.value) {
    return 0
  }
  if (70750...70750).contains(scalar.value) {
    return 0
  }
  if (70835...70840).contains(scalar.value) {
    return 0
  }
  if (70842...70842).contains(scalar.value) {
    return 0
  }
  if (70847...70848).contains(scalar.value) {
    return 0
  }
  if (70850...70851).contains(scalar.value) {
    return 0
  }
  if (71090...71093).contains(scalar.value) {
    return 0
  }
  if (71100...71101).contains(scalar.value) {
    return 0
  }
  if (71103...71104).contains(scalar.value) {
    return 0
  }
  if (71132...71133).contains(scalar.value) {
    return 0
  }
  if (71219...71226).contains(scalar.value) {
    return 0
  }
  if (71229...71229).contains(scalar.value) {
    return 0
  }
  if (71231...71232).contains(scalar.value) {
    return 0
  }
  if (71339...71339).contains(scalar.value) {
    return 0
  }
  if (71341...71341).contains(scalar.value) {
    return 0
  }
  if (71344...71349).contains(scalar.value) {
    return 0
  }
  if (71351...71351).contains(scalar.value) {
    return 0
  }
  if (71453...71455).contains(scalar.value) {
    return 0
  }
  if (71458...71461).contains(scalar.value) {
    return 0
  }
  if (71463...71467).contains(scalar.value) {
    return 0
  }
  if (71727...71735).contains(scalar.value) {
    return 0
  }
  if (71737...71738).contains(scalar.value) {
    return 0
  }
  if (71995...71996).contains(scalar.value) {
    return 0
  }
  if (71998...71998).contains(scalar.value) {
    return 0
  }
  if (72003...72003).contains(scalar.value) {
    return 0
  }
  if (72148...72151).contains(scalar.value) {
    return 0
  }
  if (72154...72155).contains(scalar.value) {
    return 0
  }
  if (72160...72160).contains(scalar.value) {
    return 0
  }
  if (72193...72202).contains(scalar.value) {
    return 0
  }
  if (72243...72248).contains(scalar.value) {
    return 0
  }
  if (72251...72254).contains(scalar.value) {
    return 0
  }
  if (72263...72263).contains(scalar.value) {
    return 0
  }
  if (72273...72278).contains(scalar.value) {
    return 0
  }
  if (72281...72283).contains(scalar.value) {
    return 0
  }
  if (72330...72342).contains(scalar.value) {
    return 0
  }
  if (72344...72345).contains(scalar.value) {
    return 0
  }
  if (72752...72758).contains(scalar.value) {
    return 0
  }
  if (72760...72765).contains(scalar.value) {
    return 0
  }
  if (72767...72767).contains(scalar.value) {
    return 0
  }
  if (72850...72871).contains(scalar.value) {
    return 0
  }
  if (72874...72880).contains(scalar.value) {
    return 0
  }
  if (72882...72883).contains(scalar.value) {
    return 0
  }
  if (72885...72886).contains(scalar.value) {
    return 0
  }
  if (73009...73014).contains(scalar.value) {
    return 0
  }
  if (73018...73018).contains(scalar.value) {
    return 0
  }
  if (73020...73021).contains(scalar.value) {
    return 0
  }
  if (73023...73029).contains(scalar.value) {
    return 0
  }
  if (73031...73031).contains(scalar.value) {
    return 0
  }
  if (73104...73105).contains(scalar.value) {
    return 0
  }
  if (73109...73109).contains(scalar.value) {
    return 0
  }
  if (73111...73111).contains(scalar.value) {
    return 0
  }
  if (73459...73460).contains(scalar.value) {
    return 0
  }
  if (73472...73473).contains(scalar.value) {
    return 0
  }
  if (73526...73530).contains(scalar.value) {
    return 0
  }
  if (73536...73536).contains(scalar.value) {
    return 0
  }
  if (73538...73538).contains(scalar.value) {
    return 0
  }
  if (78912...78912).contains(scalar.value) {
    return 0
  }
  if (78919...78933).contains(scalar.value) {
    return 0
  }
  if (92912...92916).contains(scalar.value) {
    return 0
  }
  if (92976...92982).contains(scalar.value) {
    return 0
  }
  if (94031...94031).contains(scalar.value) {
    return 0
  }
  if (94095...94098).contains(scalar.value) {
    return 0
  }
  if (94180...94180).contains(scalar.value) {
    return 0
  }
  if (113821...113822).contains(scalar.value) {
    return 0
  }
  if (118528...118573).contains(scalar.value) {
    return 0
  }
  if (118576...118598).contains(scalar.value) {
    return 0
  }
  if (119143...119145).contains(scalar.value) {
    return 0
  }
  if (119163...119170).contains(scalar.value) {
    return 0
  }
  if (119173...119179).contains(scalar.value) {
    return 0
  }
  if (119210...119213).contains(scalar.value) {
    return 0
  }
  if (119362...119364).contains(scalar.value) {
    return 0
  }
  if (121344...121398).contains(scalar.value) {
    return 0
  }
  if (121403...121452).contains(scalar.value) {
    return 0
  }
  if (121461...121461).contains(scalar.value) {
    return 0
  }
  if (121476...121476).contains(scalar.value) {
    return 0
  }
  if (121499...121503).contains(scalar.value) {
    return 0
  }
  if (121505...121519).contains(scalar.value) {
    return 0
  }
  if (122880...122886).contains(scalar.value) {
    return 0
  }
  if (122888...122904).contains(scalar.value) {
    return 0
  }
  if (122907...122913).contains(scalar.value) {
    return 0
  }
  if (122915...122916).contains(scalar.value) {
    return 0
  }
  if (122918...122922).contains(scalar.value) {
    return 0
  }
  if (123023...123023).contains(scalar.value) {
    return 0
  }
  if (123184...123190).contains(scalar.value) {
    return 0
  }
  if (123566...123566).contains(scalar.value) {
    return 0
  }
  if (123628...123631).contains(scalar.value) {
    return 0
  }
  if (124140...124143).contains(scalar.value) {
    return 0
  }
  if (125136...125142).contains(scalar.value) {
    return 0
  }
  if (125252...125258).contains(scalar.value) {
    return 0
  }
  if (917760...917999).contains(scalar.value) {
    return 0
  }
  if (0...31).contains(scalar.value) {
    return 1
  }
  if (32...126).contains(scalar.value) {
    return 1
  }
  if (127...160).contains(scalar.value) {
    return 1
  }
  if (161...161).contains(scalar.value) {
    return 1
  }
  if (162...163).contains(scalar.value) {
    return 1
  }
  if (164...164).contains(scalar.value) {
    return 1
  }
  if (165...166).contains(scalar.value) {
    return 1
  }
  if (167...168).contains(scalar.value) {
    return 1
  }
  if (169...169).contains(scalar.value) {
    return 1
  }
  if (170...170).contains(scalar.value) {
    return 1
  }
  if (171...171).contains(scalar.value) {
    return 1
  }
  if (172...172).contains(scalar.value) {
    return 1
  }
  if (173...174).contains(scalar.value) {
    return 1
  }
  if (175...175).contains(scalar.value) {
    return 1
  }
  if (176...180).contains(scalar.value) {
    return 1
  }
  if (181...181).contains(scalar.value) {
    return 1
  }
  if (182...186).contains(scalar.value) {
    return 1
  }
  if (187...187).contains(scalar.value) {
    return 1
  }
  if (188...191).contains(scalar.value) {
    return 1
  }
  if (192...197).contains(scalar.value) {
    return 1
  }
  if (198...198).contains(scalar.value) {
    return 1
  }
  if (199...207).contains(scalar.value) {
    return 1
  }
  if (208...208).contains(scalar.value) {
    return 1
  }
  if (209...214).contains(scalar.value) {
    return 1
  }
  if (215...216).contains(scalar.value) {
    return 1
  }
  if (217...221).contains(scalar.value) {
    return 1
  }
  if (222...225).contains(scalar.value) {
    return 1
  }
  if (226...229).contains(scalar.value) {
    return 1
  }
  if (230...230).contains(scalar.value) {
    return 1
  }
  if (231...231).contains(scalar.value) {
    return 1
  }
  if (232...234).contains(scalar.value) {
    return 1
  }
  if (235...235).contains(scalar.value) {
    return 1
  }
  if (236...237).contains(scalar.value) {
    return 1
  }
  if (238...239).contains(scalar.value) {
    return 1
  }
  if (240...240).contains(scalar.value) {
    return 1
  }
  if (241...241).contains(scalar.value) {
    return 1
  }
  if (242...243).contains(scalar.value) {
    return 1
  }
  if (244...246).contains(scalar.value) {
    return 1
  }
  if (247...250).contains(scalar.value) {
    return 1
  }
  if (251...251).contains(scalar.value) {
    return 1
  }
  if (252...252).contains(scalar.value) {
    return 1
  }
  if (253...253).contains(scalar.value) {
    return 1
  }
  if (254...254).contains(scalar.value) {
    return 1
  }
  if (255...256).contains(scalar.value) {
    return 1
  }
  if (257...257).contains(scalar.value) {
    return 1
  }
  if (258...272).contains(scalar.value) {
    return 1
  }
  if (273...273).contains(scalar.value) {
    return 1
  }
  if (274...274).contains(scalar.value) {
    return 1
  }
  if (275...275).contains(scalar.value) {
    return 1
  }
  if (276...282).contains(scalar.value) {
    return 1
  }
  if (283...283).contains(scalar.value) {
    return 1
  }
  if (284...293).contains(scalar.value) {
    return 1
  }
  if (294...295).contains(scalar.value) {
    return 1
  }
  if (296...298).contains(scalar.value) {
    return 1
  }
  if (299...299).contains(scalar.value) {
    return 1
  }
  if (300...304).contains(scalar.value) {
    return 1
  }
  if (305...307).contains(scalar.value) {
    return 1
  }
  if (308...311).contains(scalar.value) {
    return 1
  }
  if (312...312).contains(scalar.value) {
    return 1
  }
  if (313...318).contains(scalar.value) {
    return 1
  }
  if (319...322).contains(scalar.value) {
    return 1
  }
  if (323...323).contains(scalar.value) {
    return 1
  }
  if (324...324).contains(scalar.value) {
    return 1
  }
  if (325...327).contains(scalar.value) {
    return 1
  }
  if (328...331).contains(scalar.value) {
    return 1
  }
  if (332...332).contains(scalar.value) {
    return 1
  }
  if (333...333).contains(scalar.value) {
    return 1
  }
  if (334...337).contains(scalar.value) {
    return 1
  }
  if (338...339).contains(scalar.value) {
    return 1
  }
  if (340...357).contains(scalar.value) {
    return 1
  }
  if (358...359).contains(scalar.value) {
    return 1
  }
  if (360...362).contains(scalar.value) {
    return 1
  }
  if (363...363).contains(scalar.value) {
    return 1
  }
  if (364...461).contains(scalar.value) {
    return 1
  }
  if (462...462).contains(scalar.value) {
    return 1
  }
  if (463...463).contains(scalar.value) {
    return 1
  }
  if (464...464).contains(scalar.value) {
    return 1
  }
  if (465...465).contains(scalar.value) {
    return 1
  }
  if (466...466).contains(scalar.value) {
    return 1
  }
  if (467...467).contains(scalar.value) {
    return 1
  }
  if (468...468).contains(scalar.value) {
    return 1
  }
  if (469...469).contains(scalar.value) {
    return 1
  }
  if (470...470).contains(scalar.value) {
    return 1
  }
  if (471...471).contains(scalar.value) {
    return 1
  }
  if (472...472).contains(scalar.value) {
    return 1
  }
  if (473...473).contains(scalar.value) {
    return 1
  }
  if (474...474).contains(scalar.value) {
    return 1
  }
  if (475...475).contains(scalar.value) {
    return 1
  }
  if (476...476).contains(scalar.value) {
    return 1
  }
  if (477...592).contains(scalar.value) {
    return 1
  }
  if (593...593).contains(scalar.value) {
    return 1
  }
  if (594...608).contains(scalar.value) {
    return 1
  }
  if (609...609).contains(scalar.value) {
    return 1
  }
  if (610...707).contains(scalar.value) {
    return 1
  }
  if (708...708).contains(scalar.value) {
    return 1
  }
  if (709...710).contains(scalar.value) {
    return 1
  }
  if (711...711).contains(scalar.value) {
    return 1
  }
  if (712...712).contains(scalar.value) {
    return 1
  }
  if (713...715).contains(scalar.value) {
    return 1
  }
  if (716...716).contains(scalar.value) {
    return 1
  }
  if (717...717).contains(scalar.value) {
    return 1
  }
  if (718...719).contains(scalar.value) {
    return 1
  }
  if (720...720).contains(scalar.value) {
    return 1
  }
  if (721...727).contains(scalar.value) {
    return 1
  }
  if (728...731).contains(scalar.value) {
    return 1
  }
  if (732...732).contains(scalar.value) {
    return 1
  }
  if (733...733).contains(scalar.value) {
    return 1
  }
  if (734...734).contains(scalar.value) {
    return 1
  }
  if (735...735).contains(scalar.value) {
    return 1
  }
  if (736...767).contains(scalar.value) {
    return 1
  }
  if (768...879).contains(scalar.value) {
    return 1
  }
  if (880...887).contains(scalar.value) {
    return 1
  }
  if (890...895).contains(scalar.value) {
    return 1
  }
  if (900...906).contains(scalar.value) {
    return 1
  }
  if (908...908).contains(scalar.value) {
    return 1
  }
  if (910...912).contains(scalar.value) {
    return 1
  }
  if (913...929).contains(scalar.value) {
    return 1
  }
  if (931...937).contains(scalar.value) {
    return 1
  }
  if (938...944).contains(scalar.value) {
    return 1
  }
  if (945...961).contains(scalar.value) {
    return 1
  }
  if (962...962).contains(scalar.value) {
    return 1
  }
  if (963...969).contains(scalar.value) {
    return 1
  }
  if (970...1024).contains(scalar.value) {
    return 1
  }
  if (1025...1025).contains(scalar.value) {
    return 1
  }
  if (1026...1039).contains(scalar.value) {
    return 1
  }
  if (1040...1103).contains(scalar.value) {
    return 1
  }
  if (1104...1104).contains(scalar.value) {
    return 1
  }
  if (1105...1105).contains(scalar.value) {
    return 1
  }
  if (1106...1327).contains(scalar.value) {
    return 1
  }
  if (1329...1366).contains(scalar.value) {
    return 1
  }
  if (1369...1418).contains(scalar.value) {
    return 1
  }
  if (1421...1423).contains(scalar.value) {
    return 1
  }
  if (1425...1479).contains(scalar.value) {
    return 1
  }
  if (1488...1514).contains(scalar.value) {
    return 1
  }
  if (1519...1524).contains(scalar.value) {
    return 1
  }
  if (1536...1805).contains(scalar.value) {
    return 1
  }
  if (1807...1866).contains(scalar.value) {
    return 1
  }
  if (1869...1969).contains(scalar.value) {
    return 1
  }
  if (1984...2042).contains(scalar.value) {
    return 1
  }
  if (2045...2093).contains(scalar.value) {
    return 1
  }
  if (2096...2110).contains(scalar.value) {
    return 1
  }
  if (2112...2139).contains(scalar.value) {
    return 1
  }
  if (2142...2142).contains(scalar.value) {
    return 1
  }
  if (2144...2154).contains(scalar.value) {
    return 1
  }
  if (2160...2190).contains(scalar.value) {
    return 1
  }
  if (2192...2193).contains(scalar.value) {
    return 1
  }
  if (2200...2435).contains(scalar.value) {
    return 1
  }
  if (2437...2444).contains(scalar.value) {
    return 1
  }
  if (2447...2448).contains(scalar.value) {
    return 1
  }
  if (2451...2472).contains(scalar.value) {
    return 1
  }
  if (2474...2480).contains(scalar.value) {
    return 1
  }
  if (2482...2482).contains(scalar.value) {
    return 1
  }
  if (2486...2489).contains(scalar.value) {
    return 1
  }
  if (2492...2500).contains(scalar.value) {
    return 1
  }
  if (2503...2504).contains(scalar.value) {
    return 1
  }
  if (2507...2510).contains(scalar.value) {
    return 1
  }
  if (2519...2519).contains(scalar.value) {
    return 1
  }
  if (2524...2525).contains(scalar.value) {
    return 1
  }
  if (2527...2531).contains(scalar.value) {
    return 1
  }
  if (2534...2558).contains(scalar.value) {
    return 1
  }
  if (2561...2563).contains(scalar.value) {
    return 1
  }
  if (2565...2570).contains(scalar.value) {
    return 1
  }
  if (2575...2576).contains(scalar.value) {
    return 1
  }
  if (2579...2600).contains(scalar.value) {
    return 1
  }
  if (2602...2608).contains(scalar.value) {
    return 1
  }
  if (2610...2611).contains(scalar.value) {
    return 1
  }
  if (2613...2614).contains(scalar.value) {
    return 1
  }
  if (2616...2617).contains(scalar.value) {
    return 1
  }
  if (2620...2620).contains(scalar.value) {
    return 1
  }
  if (2622...2626).contains(scalar.value) {
    return 1
  }
  if (2631...2632).contains(scalar.value) {
    return 1
  }
  if (2635...2637).contains(scalar.value) {
    return 1
  }
  if (2641...2641).contains(scalar.value) {
    return 1
  }
  if (2649...2652).contains(scalar.value) {
    return 1
  }
  if (2654...2654).contains(scalar.value) {
    return 1
  }
  if (2662...2678).contains(scalar.value) {
    return 1
  }
  if (2689...2691).contains(scalar.value) {
    return 1
  }
  if (2693...2701).contains(scalar.value) {
    return 1
  }
  if (2703...2705).contains(scalar.value) {
    return 1
  }
  if (2707...2728).contains(scalar.value) {
    return 1
  }
  if (2730...2736).contains(scalar.value) {
    return 1
  }
  if (2738...2739).contains(scalar.value) {
    return 1
  }
  if (2741...2745).contains(scalar.value) {
    return 1
  }
  if (2748...2757).contains(scalar.value) {
    return 1
  }
  if (2759...2761).contains(scalar.value) {
    return 1
  }
  if (2763...2765).contains(scalar.value) {
    return 1
  }
  if (2768...2768).contains(scalar.value) {
    return 1
  }
  if (2784...2787).contains(scalar.value) {
    return 1
  }
  if (2790...2801).contains(scalar.value) {
    return 1
  }
  if (2809...2815).contains(scalar.value) {
    return 1
  }
  if (2817...2819).contains(scalar.value) {
    return 1
  }
  if (2821...2828).contains(scalar.value) {
    return 1
  }
  if (2831...2832).contains(scalar.value) {
    return 1
  }
  if (2835...2856).contains(scalar.value) {
    return 1
  }
  if (2858...2864).contains(scalar.value) {
    return 1
  }
  if (2866...2867).contains(scalar.value) {
    return 1
  }
  if (2869...2873).contains(scalar.value) {
    return 1
  }
  if (2876...2884).contains(scalar.value) {
    return 1
  }
  if (2887...2888).contains(scalar.value) {
    return 1
  }
  if (2891...2893).contains(scalar.value) {
    return 1
  }
  if (2901...2903).contains(scalar.value) {
    return 1
  }
  if (2908...2909).contains(scalar.value) {
    return 1
  }
  if (2911...2915).contains(scalar.value) {
    return 1
  }
  if (2918...2935).contains(scalar.value) {
    return 1
  }
  if (2946...2947).contains(scalar.value) {
    return 1
  }
  if (2949...2954).contains(scalar.value) {
    return 1
  }
  if (2958...2960).contains(scalar.value) {
    return 1
  }
  if (2962...2965).contains(scalar.value) {
    return 1
  }
  if (2969...2970).contains(scalar.value) {
    return 1
  }
  if (2972...2972).contains(scalar.value) {
    return 1
  }
  if (2974...2975).contains(scalar.value) {
    return 1
  }
  if (2979...2980).contains(scalar.value) {
    return 1
  }
  if (2984...2986).contains(scalar.value) {
    return 1
  }
  if (2990...3001).contains(scalar.value) {
    return 1
  }
  if (3006...3010).contains(scalar.value) {
    return 1
  }
  if (3014...3016).contains(scalar.value) {
    return 1
  }
  if (3018...3021).contains(scalar.value) {
    return 1
  }
  if (3024...3024).contains(scalar.value) {
    return 1
  }
  if (3031...3031).contains(scalar.value) {
    return 1
  }
  if (3046...3066).contains(scalar.value) {
    return 1
  }
  if (3072...3084).contains(scalar.value) {
    return 1
  }
  if (3086...3088).contains(scalar.value) {
    return 1
  }
  if (3090...3112).contains(scalar.value) {
    return 1
  }
  if (3114...3129).contains(scalar.value) {
    return 1
  }
  if (3132...3140).contains(scalar.value) {
    return 1
  }
  if (3142...3144).contains(scalar.value) {
    return 1
  }
  if (3146...3149).contains(scalar.value) {
    return 1
  }
  if (3157...3158).contains(scalar.value) {
    return 1
  }
  if (3160...3162).contains(scalar.value) {
    return 1
  }
  if (3165...3165).contains(scalar.value) {
    return 1
  }
  if (3168...3171).contains(scalar.value) {
    return 1
  }
  if (3174...3183).contains(scalar.value) {
    return 1
  }
  if (3191...3212).contains(scalar.value) {
    return 1
  }
  if (3214...3216).contains(scalar.value) {
    return 1
  }
  if (3218...3240).contains(scalar.value) {
    return 1
  }
  if (3242...3251).contains(scalar.value) {
    return 1
  }
  if (3253...3257).contains(scalar.value) {
    return 1
  }
  if (3260...3268).contains(scalar.value) {
    return 1
  }
  if (3270...3272).contains(scalar.value) {
    return 1
  }
  if (3274...3277).contains(scalar.value) {
    return 1
  }
  if (3285...3286).contains(scalar.value) {
    return 1
  }
  if (3293...3294).contains(scalar.value) {
    return 1
  }
  if (3296...3299).contains(scalar.value) {
    return 1
  }
  if (3302...3311).contains(scalar.value) {
    return 1
  }
  if (3313...3315).contains(scalar.value) {
    return 1
  }
  if (3328...3340).contains(scalar.value) {
    return 1
  }
  if (3342...3344).contains(scalar.value) {
    return 1
  }
  if (3346...3396).contains(scalar.value) {
    return 1
  }
  if (3398...3400).contains(scalar.value) {
    return 1
  }
  if (3402...3407).contains(scalar.value) {
    return 1
  }
  if (3412...3427).contains(scalar.value) {
    return 1
  }
  if (3430...3455).contains(scalar.value) {
    return 1
  }
  if (3457...3459).contains(scalar.value) {
    return 1
  }
  if (3461...3478).contains(scalar.value) {
    return 1
  }
  if (3482...3505).contains(scalar.value) {
    return 1
  }
  if (3507...3515).contains(scalar.value) {
    return 1
  }
  if (3517...3517).contains(scalar.value) {
    return 1
  }
  if (3520...3526).contains(scalar.value) {
    return 1
  }
  if (3530...3530).contains(scalar.value) {
    return 1
  }
  if (3535...3540).contains(scalar.value) {
    return 1
  }
  if (3542...3542).contains(scalar.value) {
    return 1
  }
  if (3544...3551).contains(scalar.value) {
    return 1
  }
  if (3558...3567).contains(scalar.value) {
    return 1
  }
  if (3570...3572).contains(scalar.value) {
    return 1
  }
  if (3585...3642).contains(scalar.value) {
    return 1
  }
  if (3647...3675).contains(scalar.value) {
    return 1
  }
  if (3713...3714).contains(scalar.value) {
    return 1
  }
  if (3716...3716).contains(scalar.value) {
    return 1
  }
  if (3718...3722).contains(scalar.value) {
    return 1
  }
  if (3724...3747).contains(scalar.value) {
    return 1
  }
  if (3749...3749).contains(scalar.value) {
    return 1
  }
  if (3751...3773).contains(scalar.value) {
    return 1
  }
  if (3776...3780).contains(scalar.value) {
    return 1
  }
  if (3782...3782).contains(scalar.value) {
    return 1
  }
  if (3784...3790).contains(scalar.value) {
    return 1
  }
  if (3792...3801).contains(scalar.value) {
    return 1
  }
  if (3804...3807).contains(scalar.value) {
    return 1
  }
  if (3840...3911).contains(scalar.value) {
    return 1
  }
  if (3913...3948).contains(scalar.value) {
    return 1
  }
  if (3953...3991).contains(scalar.value) {
    return 1
  }
  if (3993...4028).contains(scalar.value) {
    return 1
  }
  if (4030...4044).contains(scalar.value) {
    return 1
  }
  if (4046...4058).contains(scalar.value) {
    return 1
  }
  if (4096...4293).contains(scalar.value) {
    return 1
  }
  if (4295...4295).contains(scalar.value) {
    return 1
  }
  if (4301...4301).contains(scalar.value) {
    return 1
  }
  if (4304...4351).contains(scalar.value) {
    return 1
  }
  if (4352...4447).contains(scalar.value) {
    return 2
  }
  if (4448...4680).contains(scalar.value) {
    return 1
  }
  if (4682...4685).contains(scalar.value) {
    return 1
  }
  if (4688...4694).contains(scalar.value) {
    return 1
  }
  if (4696...4696).contains(scalar.value) {
    return 1
  }
  if (4698...4701).contains(scalar.value) {
    return 1
  }
  if (4704...4744).contains(scalar.value) {
    return 1
  }
  if (4746...4749).contains(scalar.value) {
    return 1
  }
  if (4752...4784).contains(scalar.value) {
    return 1
  }
  if (4786...4789).contains(scalar.value) {
    return 1
  }
  if (4792...4798).contains(scalar.value) {
    return 1
  }
  if (4800...4800).contains(scalar.value) {
    return 1
  }
  if (4802...4805).contains(scalar.value) {
    return 1
  }
  if (4808...4822).contains(scalar.value) {
    return 1
  }
  if (4824...4880).contains(scalar.value) {
    return 1
  }
  if (4882...4885).contains(scalar.value) {
    return 1
  }
  if (4888...4954).contains(scalar.value) {
    return 1
  }
  if (4957...4988).contains(scalar.value) {
    return 1
  }
  if (4992...5017).contains(scalar.value) {
    return 1
  }
  if (5024...5109).contains(scalar.value) {
    return 1
  }
  if (5112...5117).contains(scalar.value) {
    return 1
  }
  if (5120...5788).contains(scalar.value) {
    return 1
  }
  if (5792...5880).contains(scalar.value) {
    return 1
  }
  if (5888...5909).contains(scalar.value) {
    return 1
  }
  if (5919...5942).contains(scalar.value) {
    return 1
  }
  if (5952...5971).contains(scalar.value) {
    return 1
  }
  if (5984...5996).contains(scalar.value) {
    return 1
  }
  if (5998...6000).contains(scalar.value) {
    return 1
  }
  if (6002...6003).contains(scalar.value) {
    return 1
  }
  if (6016...6109).contains(scalar.value) {
    return 1
  }
  if (6112...6121).contains(scalar.value) {
    return 1
  }
  if (6128...6137).contains(scalar.value) {
    return 1
  }
  if (6144...6169).contains(scalar.value) {
    return 1
  }
  if (6176...6264).contains(scalar.value) {
    return 1
  }
  if (6272...6314).contains(scalar.value) {
    return 1
  }
  if (6320...6389).contains(scalar.value) {
    return 1
  }
  if (6400...6430).contains(scalar.value) {
    return 1
  }
  if (6432...6443).contains(scalar.value) {
    return 1
  }
  if (6448...6459).contains(scalar.value) {
    return 1
  }
  if (6464...6464).contains(scalar.value) {
    return 1
  }
  if (6468...6509).contains(scalar.value) {
    return 1
  }
  if (6512...6516).contains(scalar.value) {
    return 1
  }
  if (6528...6571).contains(scalar.value) {
    return 1
  }
  if (6576...6601).contains(scalar.value) {
    return 1
  }
  if (6608...6618).contains(scalar.value) {
    return 1
  }
  if (6622...6683).contains(scalar.value) {
    return 1
  }
  if (6686...6750).contains(scalar.value) {
    return 1
  }
  if (6752...6780).contains(scalar.value) {
    return 1
  }
  if (6783...6793).contains(scalar.value) {
    return 1
  }
  if (6800...6809).contains(scalar.value) {
    return 1
  }
  if (6816...6829).contains(scalar.value) {
    return 1
  }
  if (6832...6862).contains(scalar.value) {
    return 1
  }
  if (6912...6988).contains(scalar.value) {
    return 1
  }
  if (6992...7038).contains(scalar.value) {
    return 1
  }
  if (7040...7155).contains(scalar.value) {
    return 1
  }
  if (7164...7223).contains(scalar.value) {
    return 1
  }
  if (7227...7241).contains(scalar.value) {
    return 1
  }
  if (7245...7304).contains(scalar.value) {
    return 1
  }
  if (7312...7354).contains(scalar.value) {
    return 1
  }
  if (7357...7367).contains(scalar.value) {
    return 1
  }
  if (7376...7418).contains(scalar.value) {
    return 1
  }
  if (7424...7957).contains(scalar.value) {
    return 1
  }
  if (7960...7965).contains(scalar.value) {
    return 1
  }
  if (7968...8005).contains(scalar.value) {
    return 1
  }
  if (8008...8013).contains(scalar.value) {
    return 1
  }
  if (8016...8023).contains(scalar.value) {
    return 1
  }
  if (8025...8025).contains(scalar.value) {
    return 1
  }
  if (8027...8027).contains(scalar.value) {
    return 1
  }
  if (8029...8029).contains(scalar.value) {
    return 1
  }
  if (8031...8061).contains(scalar.value) {
    return 1
  }
  if (8064...8116).contains(scalar.value) {
    return 1
  }
  if (8118...8132).contains(scalar.value) {
    return 1
  }
  if (8134...8147).contains(scalar.value) {
    return 1
  }
  if (8150...8155).contains(scalar.value) {
    return 1
  }
  if (8157...8175).contains(scalar.value) {
    return 1
  }
  if (8178...8180).contains(scalar.value) {
    return 1
  }
  if (8182...8190).contains(scalar.value) {
    return 1
  }
  if (8192...8207).contains(scalar.value) {
    return 1
  }
  if (8208...8208).contains(scalar.value) {
    return 1
  }
  if (8209...8210).contains(scalar.value) {
    return 1
  }
  if (8211...8214).contains(scalar.value) {
    return 1
  }
  if (8215...8215).contains(scalar.value) {
    return 1
  }
  if (8216...8217).contains(scalar.value) {
    return 1
  }
  if (8218...8219).contains(scalar.value) {
    return 1
  }
  if (8220...8221).contains(scalar.value) {
    return 1
  }
  if (8222...8223).contains(scalar.value) {
    return 1
  }
  if (8224...8226).contains(scalar.value) {
    return 1
  }
  if (8227...8227).contains(scalar.value) {
    return 1
  }
  if (8228...8231).contains(scalar.value) {
    return 1
  }
  if (8232...8239).contains(scalar.value) {
    return 1
  }
  if (8240...8240).contains(scalar.value) {
    return 1
  }
  if (8241...8241).contains(scalar.value) {
    return 1
  }
  if (8242...8243).contains(scalar.value) {
    return 1
  }
  if (8244...8244).contains(scalar.value) {
    return 1
  }
  if (8245...8245).contains(scalar.value) {
    return 1
  }
  if (8246...8250).contains(scalar.value) {
    return 1
  }
  if (8251...8251).contains(scalar.value) {
    return 1
  }
  if (8252...8253).contains(scalar.value) {
    return 1
  }
  if (8254...8254).contains(scalar.value) {
    return 1
  }
  if (8255...8292).contains(scalar.value) {
    return 1
  }
  if (8294...8305).contains(scalar.value) {
    return 1
  }
  if (8308...8308).contains(scalar.value) {
    return 1
  }
  if (8309...8318).contains(scalar.value) {
    return 1
  }
  if (8319...8319).contains(scalar.value) {
    return 1
  }
  if (8320...8320).contains(scalar.value) {
    return 1
  }
  if (8321...8324).contains(scalar.value) {
    return 1
  }
  if (8325...8334).contains(scalar.value) {
    return 1
  }
  if (8336...8348).contains(scalar.value) {
    return 1
  }
  if (8352...8360).contains(scalar.value) {
    return 1
  }
  if (8361...8361).contains(scalar.value) {
    return 1
  }
  if (8362...8363).contains(scalar.value) {
    return 1
  }
  if (8364...8364).contains(scalar.value) {
    return 1
  }
  if (8365...8384).contains(scalar.value) {
    return 1
  }
  if (8400...8432).contains(scalar.value) {
    return 1
  }
  if (8448...8450).contains(scalar.value) {
    return 1
  }
  if (8451...8451).contains(scalar.value) {
    return 1
  }
  if (8452...8452).contains(scalar.value) {
    return 1
  }
  if (8453...8453).contains(scalar.value) {
    return 1
  }
  if (8454...8456).contains(scalar.value) {
    return 1
  }
  if (8457...8457).contains(scalar.value) {
    return 1
  }
  if (8458...8466).contains(scalar.value) {
    return 1
  }
  if (8467...8467).contains(scalar.value) {
    return 1
  }
  if (8468...8469).contains(scalar.value) {
    return 1
  }
  if (8470...8470).contains(scalar.value) {
    return 1
  }
  if (8471...8480).contains(scalar.value) {
    return 1
  }
  if (8481...8482).contains(scalar.value) {
    return 1
  }
  if (8483...8485).contains(scalar.value) {
    return 1
  }
  if (8486...8486).contains(scalar.value) {
    return 1
  }
  if (8487...8490).contains(scalar.value) {
    return 1
  }
  if (8491...8491).contains(scalar.value) {
    return 1
  }
  if (8492...8530).contains(scalar.value) {
    return 1
  }
  if (8531...8532).contains(scalar.value) {
    return 1
  }
  if (8533...8538).contains(scalar.value) {
    return 1
  }
  if (8539...8542).contains(scalar.value) {
    return 1
  }
  if (8543...8543).contains(scalar.value) {
    return 1
  }
  if (8544...8555).contains(scalar.value) {
    return 1
  }
  if (8556...8559).contains(scalar.value) {
    return 1
  }
  if (8560...8569).contains(scalar.value) {
    return 1
  }
  if (8570...8584).contains(scalar.value) {
    return 1
  }
  if (8585...8585).contains(scalar.value) {
    return 1
  }
  if (8586...8587).contains(scalar.value) {
    return 1
  }
  if (8592...8601).contains(scalar.value) {
    return 1
  }
  if (8602...8631).contains(scalar.value) {
    return 1
  }
  if (8632...8633).contains(scalar.value) {
    return 1
  }
  if (8634...8657).contains(scalar.value) {
    return 1
  }
  if (8658...8658).contains(scalar.value) {
    return 1
  }
  if (8659...8659).contains(scalar.value) {
    return 1
  }
  if (8660...8660).contains(scalar.value) {
    return 1
  }
  if (8661...8678).contains(scalar.value) {
    return 1
  }
  if (8679...8679).contains(scalar.value) {
    return 1
  }
  if (8680...8703).contains(scalar.value) {
    return 1
  }
  if (8704...8704).contains(scalar.value) {
    return 1
  }
  if (8705...8705).contains(scalar.value) {
    return 1
  }
  if (8706...8707).contains(scalar.value) {
    return 1
  }
  if (8708...8710).contains(scalar.value) {
    return 1
  }
  if (8711...8712).contains(scalar.value) {
    return 1
  }
  if (8713...8714).contains(scalar.value) {
    return 1
  }
  if (8715...8715).contains(scalar.value) {
    return 1
  }
  if (8716...8718).contains(scalar.value) {
    return 1
  }
  if (8719...8719).contains(scalar.value) {
    return 1
  }
  if (8720...8720).contains(scalar.value) {
    return 1
  }
  if (8721...8721).contains(scalar.value) {
    return 1
  }
  if (8722...8724).contains(scalar.value) {
    return 1
  }
  if (8725...8725).contains(scalar.value) {
    return 1
  }
  if (8726...8729).contains(scalar.value) {
    return 1
  }
  if (8730...8730).contains(scalar.value) {
    return 1
  }
  if (8731...8732).contains(scalar.value) {
    return 1
  }
  if (8733...8736).contains(scalar.value) {
    return 1
  }
  if (8737...8738).contains(scalar.value) {
    return 1
  }
  if (8739...8739).contains(scalar.value) {
    return 1
  }
  if (8740...8740).contains(scalar.value) {
    return 1
  }
  if (8741...8741).contains(scalar.value) {
    return 1
  }
  if (8742...8742).contains(scalar.value) {
    return 1
  }
  if (8743...8748).contains(scalar.value) {
    return 1
  }
  if (8749...8749).contains(scalar.value) {
    return 1
  }
  if (8750...8750).contains(scalar.value) {
    return 1
  }
  if (8751...8755).contains(scalar.value) {
    return 1
  }
  if (8756...8759).contains(scalar.value) {
    return 1
  }
  if (8760...8763).contains(scalar.value) {
    return 1
  }
  if (8764...8765).contains(scalar.value) {
    return 1
  }
  if (8766...8775).contains(scalar.value) {
    return 1
  }
  if (8776...8776).contains(scalar.value) {
    return 1
  }
  if (8777...8779).contains(scalar.value) {
    return 1
  }
  if (8780...8780).contains(scalar.value) {
    return 1
  }
  if (8781...8785).contains(scalar.value) {
    return 1
  }
  if (8786...8786).contains(scalar.value) {
    return 1
  }
  if (8787...8799).contains(scalar.value) {
    return 1
  }
  if (8800...8801).contains(scalar.value) {
    return 1
  }
  if (8802...8803).contains(scalar.value) {
    return 1
  }
  if (8804...8807).contains(scalar.value) {
    return 1
  }
  if (8808...8809).contains(scalar.value) {
    return 1
  }
  if (8810...8811).contains(scalar.value) {
    return 1
  }
  if (8812...8813).contains(scalar.value) {
    return 1
  }
  if (8814...8815).contains(scalar.value) {
    return 1
  }
  if (8816...8833).contains(scalar.value) {
    return 1
  }
  if (8834...8835).contains(scalar.value) {
    return 1
  }
  if (8836...8837).contains(scalar.value) {
    return 1
  }
  if (8838...8839).contains(scalar.value) {
    return 1
  }
  if (8840...8852).contains(scalar.value) {
    return 1
  }
  if (8853...8853).contains(scalar.value) {
    return 1
  }
  if (8854...8856).contains(scalar.value) {
    return 1
  }
  if (8857...8857).contains(scalar.value) {
    return 1
  }
  if (8858...8868).contains(scalar.value) {
    return 1
  }
  if (8869...8869).contains(scalar.value) {
    return 1
  }
  if (8870...8894).contains(scalar.value) {
    return 1
  }
  if (8895...8895).contains(scalar.value) {
    return 1
  }
  if (8896...8977).contains(scalar.value) {
    return 1
  }
  if (8978...8978).contains(scalar.value) {
    return 1
  }
  if (8979...8985).contains(scalar.value) {
    return 1
  }
  if (8986...8987).contains(scalar.value) {
    return 2
  }
  if (8988...9000).contains(scalar.value) {
    return 1
  }
  if (9001...9002).contains(scalar.value) {
    return 2
  }
  if (9003...9192).contains(scalar.value) {
    return 1
  }
  if (9193...9196).contains(scalar.value) {
    return 2
  }
  if (9197...9199).contains(scalar.value) {
    return 1
  }
  if (9200...9200).contains(scalar.value) {
    return 2
  }
  if (9201...9202).contains(scalar.value) {
    return 1
  }
  if (9203...9203).contains(scalar.value) {
    return 2
  }
  if (9204...9254).contains(scalar.value) {
    return 1
  }
  if (9280...9290).contains(scalar.value) {
    return 1
  }
  if (9312...9449).contains(scalar.value) {
    return 1
  }
  if (9450...9450).contains(scalar.value) {
    return 1
  }
  if (9451...9547).contains(scalar.value) {
    return 1
  }
  if (9548...9551).contains(scalar.value) {
    return 1
  }
  if (9552...9587).contains(scalar.value) {
    return 1
  }
  if (9588...9599).contains(scalar.value) {
    return 1
  }
  if (9600...9615).contains(scalar.value) {
    return 1
  }
  if (9616...9617).contains(scalar.value) {
    return 1
  }
  if (9618...9621).contains(scalar.value) {
    return 1
  }
  if (9622...9631).contains(scalar.value) {
    return 1
  }
  if (9632...9633).contains(scalar.value) {
    return 1
  }
  if (9634...9634).contains(scalar.value) {
    return 1
  }
  if (9635...9641).contains(scalar.value) {
    return 1
  }
  if (9642...9649).contains(scalar.value) {
    return 1
  }
  if (9650...9651).contains(scalar.value) {
    return 1
  }
  if (9652...9653).contains(scalar.value) {
    return 1
  }
  if (9654...9655).contains(scalar.value) {
    return 1
  }
  if (9656...9659).contains(scalar.value) {
    return 1
  }
  if (9660...9661).contains(scalar.value) {
    return 1
  }
  if (9662...9663).contains(scalar.value) {
    return 1
  }
  if (9664...9665).contains(scalar.value) {
    return 1
  }
  if (9666...9669).contains(scalar.value) {
    return 1
  }
  if (9670...9672).contains(scalar.value) {
    return 1
  }
  if (9673...9674).contains(scalar.value) {
    return 1
  }
  if (9675...9675).contains(scalar.value) {
    return 1
  }
  if (9676...9677).contains(scalar.value) {
    return 1
  }
  if (9678...9681).contains(scalar.value) {
    return 1
  }
  if (9682...9697).contains(scalar.value) {
    return 1
  }
  if (9698...9701).contains(scalar.value) {
    return 1
  }
  if (9702...9710).contains(scalar.value) {
    return 1
  }
  if (9711...9711).contains(scalar.value) {
    return 1
  }
  if (9712...9724).contains(scalar.value) {
    return 1
  }
  if (9725...9726).contains(scalar.value) {
    return 2
  }
  if (9727...9732).contains(scalar.value) {
    return 1
  }
  if (9733...9734).contains(scalar.value) {
    return 1
  }
  if (9735...9736).contains(scalar.value) {
    return 1
  }
  if (9737...9737).contains(scalar.value) {
    return 1
  }
  if (9738...9741).contains(scalar.value) {
    return 1
  }
  if (9742...9743).contains(scalar.value) {
    return 1
  }
  if (9744...9747).contains(scalar.value) {
    return 1
  }
  if (9748...9749).contains(scalar.value) {
    return 2
  }
  if (9750...9755).contains(scalar.value) {
    return 1
  }
  if (9756...9756).contains(scalar.value) {
    return 1
  }
  if (9757...9757).contains(scalar.value) {
    return 1
  }
  if (9758...9758).contains(scalar.value) {
    return 1
  }
  if (9759...9791).contains(scalar.value) {
    return 1
  }
  if (9792...9792).contains(scalar.value) {
    return 1
  }
  if (9793...9793).contains(scalar.value) {
    return 1
  }
  if (9794...9794).contains(scalar.value) {
    return 1
  }
  if (9795...9799).contains(scalar.value) {
    return 1
  }
  if (9800...9811).contains(scalar.value) {
    return 2
  }
  if (9812...9823).contains(scalar.value) {
    return 1
  }
  if (9824...9825).contains(scalar.value) {
    return 1
  }
  if (9826...9826).contains(scalar.value) {
    return 1
  }
  if (9827...9829).contains(scalar.value) {
    return 1
  }
  if (9830...9830).contains(scalar.value) {
    return 1
  }
  if (9831...9834).contains(scalar.value) {
    return 1
  }
  if (9835...9835).contains(scalar.value) {
    return 1
  }
  if (9836...9837).contains(scalar.value) {
    return 1
  }
  if (9838...9838).contains(scalar.value) {
    return 1
  }
  if (9839...9839).contains(scalar.value) {
    return 1
  }
  if (9840...9854).contains(scalar.value) {
    return 1
  }
  if (9855...9855).contains(scalar.value) {
    return 2
  }
  if (9856...9874).contains(scalar.value) {
    return 1
  }
  if (9875...9875).contains(scalar.value) {
    return 2
  }
  if (9876...9885).contains(scalar.value) {
    return 1
  }
  if (9886...9887).contains(scalar.value) {
    return 1
  }
  if (9888...9888).contains(scalar.value) {
    return 1
  }
  if (9889...9889).contains(scalar.value) {
    return 2
  }
  if (9890...9897).contains(scalar.value) {
    return 1
  }
  if (9898...9899).contains(scalar.value) {
    return 2
  }
  if (9900...9916).contains(scalar.value) {
    return 1
  }
  if (9917...9918).contains(scalar.value) {
    return 2
  }
  if (9919...9919).contains(scalar.value) {
    return 1
  }
  if (9920...9923).contains(scalar.value) {
    return 1
  }
  if (9924...9925).contains(scalar.value) {
    return 2
  }
  if (9926...9933).contains(scalar.value) {
    return 1
  }
  if (9934...9934).contains(scalar.value) {
    return 2
  }
  if (9935...9939).contains(scalar.value) {
    return 1
  }
  if (9940...9940).contains(scalar.value) {
    return 2
  }
  if (9941...9953).contains(scalar.value) {
    return 1
  }
  if (9954...9954).contains(scalar.value) {
    return 1
  }
  if (9955...9955).contains(scalar.value) {
    return 1
  }
  if (9956...9959).contains(scalar.value) {
    return 1
  }
  if (9960...9961).contains(scalar.value) {
    return 1
  }
  if (9962...9962).contains(scalar.value) {
    return 2
  }
  if (9963...9969).contains(scalar.value) {
    return 1
  }
  if (9970...9971).contains(scalar.value) {
    return 2
  }
  if (9972...9972).contains(scalar.value) {
    return 1
  }
  if (9973...9973).contains(scalar.value) {
    return 2
  }
  if (9974...9977).contains(scalar.value) {
    return 1
  }
  if (9978...9978).contains(scalar.value) {
    return 2
  }
  if (9979...9980).contains(scalar.value) {
    return 1
  }
  if (9981...9981).contains(scalar.value) {
    return 2
  }
  if (9982...9983).contains(scalar.value) {
    return 1
  }
  if (9984...9988).contains(scalar.value) {
    return 1
  }
  if (9989...9989).contains(scalar.value) {
    return 2
  }
  if (9990...9993).contains(scalar.value) {
    return 1
  }
  if (9994...9995).contains(scalar.value) {
    return 2
  }
  if (9996...10023).contains(scalar.value) {
    return 1
  }
  if (10024...10024).contains(scalar.value) {
    return 2
  }
  if (10025...10044).contains(scalar.value) {
    return 1
  }
  if (10045...10045).contains(scalar.value) {
    return 1
  }
  if (10046...10059).contains(scalar.value) {
    return 1
  }
  if (10060...10060).contains(scalar.value) {
    return 2
  }
  if (10061...10061).contains(scalar.value) {
    return 1
  }
  if (10062...10062).contains(scalar.value) {
    return 2
  }
  if (10063...10066).contains(scalar.value) {
    return 1
  }
  if (10067...10069).contains(scalar.value) {
    return 2
  }
  if (10070...10070).contains(scalar.value) {
    return 1
  }
  if (10071...10071).contains(scalar.value) {
    return 2
  }
  if (10072...10101).contains(scalar.value) {
    return 1
  }
  if (10102...10111).contains(scalar.value) {
    return 1
  }
  if (10112...10132).contains(scalar.value) {
    return 1
  }
  if (10133...10135).contains(scalar.value) {
    return 2
  }
  if (10136...10159).contains(scalar.value) {
    return 1
  }
  if (10160...10160).contains(scalar.value) {
    return 2
  }
  if (10161...10174).contains(scalar.value) {
    return 1
  }
  if (10175...10175).contains(scalar.value) {
    return 2
  }
  if (10176...10213).contains(scalar.value) {
    return 1
  }
  if (10214...10221).contains(scalar.value) {
    return 1
  }
  if (10222...10628).contains(scalar.value) {
    return 1
  }
  if (10629...10630).contains(scalar.value) {
    return 1
  }
  if (10631...11034).contains(scalar.value) {
    return 1
  }
  if (11035...11036).contains(scalar.value) {
    return 2
  }
  if (11037...11087).contains(scalar.value) {
    return 1
  }
  if (11088...11088).contains(scalar.value) {
    return 2
  }
  if (11089...11092).contains(scalar.value) {
    return 1
  }
  if (11093...11093).contains(scalar.value) {
    return 2
  }
  if (11094...11097).contains(scalar.value) {
    return 1
  }
  if (11098...11123).contains(scalar.value) {
    return 1
  }
  if (11126...11157).contains(scalar.value) {
    return 1
  }
  if (11159...11507).contains(scalar.value) {
    return 1
  }
  if (11513...11557).contains(scalar.value) {
    return 1
  }
  if (11559...11559).contains(scalar.value) {
    return 1
  }
  if (11565...11565).contains(scalar.value) {
    return 1
  }
  if (11568...11623).contains(scalar.value) {
    return 1
  }
  if (11631...11632).contains(scalar.value) {
    return 1
  }
  if (11647...11670).contains(scalar.value) {
    return 1
  }
  if (11680...11686).contains(scalar.value) {
    return 1
  }
  if (11688...11694).contains(scalar.value) {
    return 1
  }
  if (11696...11702).contains(scalar.value) {
    return 1
  }
  if (11704...11710).contains(scalar.value) {
    return 1
  }
  if (11712...11718).contains(scalar.value) {
    return 1
  }
  if (11720...11726).contains(scalar.value) {
    return 1
  }
  if (11728...11734).contains(scalar.value) {
    return 1
  }
  if (11736...11742).contains(scalar.value) {
    return 1
  }
  if (11744...11869).contains(scalar.value) {
    return 1
  }
  if (11904...11929).contains(scalar.value) {
    return 2
  }
  if (11931...12019).contains(scalar.value) {
    return 2
  }
  if (12032...12245).contains(scalar.value) {
    return 2
  }
  if (12272...12283).contains(scalar.value) {
    return 2
  }
  if (12288...12288).contains(scalar.value) {
    return 2
  }
  if (12289...12350).contains(scalar.value) {
    return 2
  }
  if (12351...12351).contains(scalar.value) {
    return 1
  }
  if (12353...12438).contains(scalar.value) {
    return 2
  }
  if (12441...12543).contains(scalar.value) {
    return 2
  }
  if (12549...12591).contains(scalar.value) {
    return 2
  }
  if (12593...12686).contains(scalar.value) {
    return 2
  }
  if (12688...12771).contains(scalar.value) {
    return 2
  }
  if (12784...12830).contains(scalar.value) {
    return 2
  }
  if (12832...12871).contains(scalar.value) {
    return 2
  }
  if (12872...12879).contains(scalar.value) {
    return 1
  }
  if (12880...19903).contains(scalar.value) {
    return 2
  }
  if (19904...19967).contains(scalar.value) {
    return 1
  }
  if (19968...42124).contains(scalar.value) {
    return 2
  }
  if (42128...42182).contains(scalar.value) {
    return 2
  }
  if (42192...42539).contains(scalar.value) {
    return 1
  }
  if (42560...42743).contains(scalar.value) {
    return 1
  }
  if (42752...42954).contains(scalar.value) {
    return 1
  }
  if (42960...42961).contains(scalar.value) {
    return 1
  }
  if (42963...42963).contains(scalar.value) {
    return 1
  }
  if (42965...42969).contains(scalar.value) {
    return 1
  }
  if (42994...43052).contains(scalar.value) {
    return 1
  }
  if (43056...43065).contains(scalar.value) {
    return 1
  }
  if (43072...43127).contains(scalar.value) {
    return 1
  }
  if (43136...43205).contains(scalar.value) {
    return 1
  }
  if (43214...43225).contains(scalar.value) {
    return 1
  }
  if (43232...43347).contains(scalar.value) {
    return 1
  }
  if (43359...43359).contains(scalar.value) {
    return 1
  }
  if (43360...43388).contains(scalar.value) {
    return 2
  }
  if (43392...43469).contains(scalar.value) {
    return 1
  }
  if (43471...43481).contains(scalar.value) {
    return 1
  }
  if (43486...43518).contains(scalar.value) {
    return 1
  }
  if (43520...43574).contains(scalar.value) {
    return 1
  }
  if (43584...43597).contains(scalar.value) {
    return 1
  }
  if (43600...43609).contains(scalar.value) {
    return 1
  }
  if (43612...43714).contains(scalar.value) {
    return 1
  }
  if (43739...43766).contains(scalar.value) {
    return 1
  }
  if (43777...43782).contains(scalar.value) {
    return 1
  }
  if (43785...43790).contains(scalar.value) {
    return 1
  }
  if (43793...43798).contains(scalar.value) {
    return 1
  }
  if (43808...43814).contains(scalar.value) {
    return 1
  }
  if (43816...43822).contains(scalar.value) {
    return 1
  }
  if (43824...43883).contains(scalar.value) {
    return 1
  }
  if (43888...44013).contains(scalar.value) {
    return 1
  }
  if (44016...44025).contains(scalar.value) {
    return 1
  }
  if (44032...55203).contains(scalar.value) {
    return 2
  }
  if (55216...55238).contains(scalar.value) {
    return 1
  }
  if (55243...55291).contains(scalar.value) {
    return 1
  }
  if (55296...57343).contains(scalar.value) {
    return 1
  }
  if (57344...63743).contains(scalar.value) {
    return 1
  }
  if (63744...64255).contains(scalar.value) {
    return 2
  }
  if (64256...64262).contains(scalar.value) {
    return 1
  }
  if (64275...64279).contains(scalar.value) {
    return 1
  }
  if (64285...64310).contains(scalar.value) {
    return 1
  }
  if (64312...64316).contains(scalar.value) {
    return 1
  }
  if (64318...64318).contains(scalar.value) {
    return 1
  }
  if (64320...64321).contains(scalar.value) {
    return 1
  }
  if (64323...64324).contains(scalar.value) {
    return 1
  }
  if (64326...64450).contains(scalar.value) {
    return 1
  }
  if (64467...64911).contains(scalar.value) {
    return 1
  }
  if (64914...64967).contains(scalar.value) {
    return 1
  }
  if (64975...64975).contains(scalar.value) {
    return 1
  }
  if (65008...65023).contains(scalar.value) {
    return 1
  }
  if (65024...65039).contains(scalar.value) {
    return 1
  }
  if (65040...65049).contains(scalar.value) {
    return 2
  }
  if (65056...65071).contains(scalar.value) {
    return 1
  }
  if (65072...65106).contains(scalar.value) {
    return 2
  }
  if (65108...65126).contains(scalar.value) {
    return 2
  }
  if (65128...65131).contains(scalar.value) {
    return 2
  }
  if (65136...65140).contains(scalar.value) {
    return 1
  }
  if (65142...65276).contains(scalar.value) {
    return 1
  }
  if (65279...65279).contains(scalar.value) {
    return 1
  }
  if (65281...65376).contains(scalar.value) {
    return 2
  }
  if (65377...65470).contains(scalar.value) {
    return 1
  }
  if (65474...65479).contains(scalar.value) {
    return 1
  }
  if (65482...65487).contains(scalar.value) {
    return 1
  }
  if (65490...65495).contains(scalar.value) {
    return 1
  }
  if (65498...65500).contains(scalar.value) {
    return 1
  }
  if (65504...65510).contains(scalar.value) {
    return 2
  }
  if (65512...65518).contains(scalar.value) {
    return 1
  }
  if (65529...65532).contains(scalar.value) {
    return 1
  }
  if (65533...65533).contains(scalar.value) {
    return 1
  }
  if (65536...65547).contains(scalar.value) {
    return 1
  }
  if (65549...65574).contains(scalar.value) {
    return 1
  }
  if (65576...65594).contains(scalar.value) {
    return 1
  }
  if (65596...65597).contains(scalar.value) {
    return 1
  }
  if (65599...65613).contains(scalar.value) {
    return 1
  }
  if (65616...65629).contains(scalar.value) {
    return 1
  }
  if (65664...65786).contains(scalar.value) {
    return 1
  }
  if (65792...65794).contains(scalar.value) {
    return 1
  }
  if (65799...65843).contains(scalar.value) {
    return 1
  }
  if (65847...65934).contains(scalar.value) {
    return 1
  }
  if (65936...65948).contains(scalar.value) {
    return 1
  }
  if (65952...65952).contains(scalar.value) {
    return 1
  }
  if (66000...66045).contains(scalar.value) {
    return 1
  }
  if (66176...66204).contains(scalar.value) {
    return 1
  }
  if (66208...66256).contains(scalar.value) {
    return 1
  }
  if (66272...66299).contains(scalar.value) {
    return 1
  }
  if (66304...66339).contains(scalar.value) {
    return 1
  }
  if (66349...66378).contains(scalar.value) {
    return 1
  }
  if (66384...66426).contains(scalar.value) {
    return 1
  }
  if (66432...66461).contains(scalar.value) {
    return 1
  }
  if (66463...66499).contains(scalar.value) {
    return 1
  }
  if (66504...66517).contains(scalar.value) {
    return 1
  }
  if (66560...66717).contains(scalar.value) {
    return 1
  }
  if (66720...66729).contains(scalar.value) {
    return 1
  }
  if (66736...66771).contains(scalar.value) {
    return 1
  }
  if (66776...66811).contains(scalar.value) {
    return 1
  }
  if (66816...66855).contains(scalar.value) {
    return 1
  }
  if (66864...66915).contains(scalar.value) {
    return 1
  }
  if (66927...66938).contains(scalar.value) {
    return 1
  }
  if (66940...66954).contains(scalar.value) {
    return 1
  }
  if (66956...66962).contains(scalar.value) {
    return 1
  }
  if (66964...66965).contains(scalar.value) {
    return 1
  }
  if (66967...66977).contains(scalar.value) {
    return 1
  }
  if (66979...66993).contains(scalar.value) {
    return 1
  }
  if (66995...67001).contains(scalar.value) {
    return 1
  }
  if (67003...67004).contains(scalar.value) {
    return 1
  }
  if (67072...67382).contains(scalar.value) {
    return 1
  }
  if (67392...67413).contains(scalar.value) {
    return 1
  }
  if (67424...67431).contains(scalar.value) {
    return 1
  }
  if (67456...67461).contains(scalar.value) {
    return 1
  }
  if (67463...67504).contains(scalar.value) {
    return 1
  }
  if (67506...67514).contains(scalar.value) {
    return 1
  }
  if (67584...67589).contains(scalar.value) {
    return 1
  }
  if (67592...67592).contains(scalar.value) {
    return 1
  }
  if (67594...67637).contains(scalar.value) {
    return 1
  }
  if (67639...67640).contains(scalar.value) {
    return 1
  }
  if (67644...67644).contains(scalar.value) {
    return 1
  }
  if (67647...67669).contains(scalar.value) {
    return 1
  }
  if (67671...67742).contains(scalar.value) {
    return 1
  }
  if (67751...67759).contains(scalar.value) {
    return 1
  }
  if (67808...67826).contains(scalar.value) {
    return 1
  }
  if (67828...67829).contains(scalar.value) {
    return 1
  }
  if (67835...67867).contains(scalar.value) {
    return 1
  }
  if (67871...67897).contains(scalar.value) {
    return 1
  }
  if (67903...67903).contains(scalar.value) {
    return 1
  }
  if (67968...68023).contains(scalar.value) {
    return 1
  }
  if (68028...68047).contains(scalar.value) {
    return 1
  }
  if (68050...68099).contains(scalar.value) {
    return 1
  }
  if (68101...68102).contains(scalar.value) {
    return 1
  }
  if (68108...68115).contains(scalar.value) {
    return 1
  }
  if (68117...68119).contains(scalar.value) {
    return 1
  }
  if (68121...68149).contains(scalar.value) {
    return 1
  }
  if (68152...68154).contains(scalar.value) {
    return 1
  }
  if (68159...68168).contains(scalar.value) {
    return 1
  }
  if (68176...68184).contains(scalar.value) {
    return 1
  }
  if (68192...68255).contains(scalar.value) {
    return 1
  }
  if (68288...68326).contains(scalar.value) {
    return 1
  }
  if (68331...68342).contains(scalar.value) {
    return 1
  }
  if (68352...68405).contains(scalar.value) {
    return 1
  }
  if (68409...68437).contains(scalar.value) {
    return 1
  }
  if (68440...68466).contains(scalar.value) {
    return 1
  }
  if (68472...68497).contains(scalar.value) {
    return 1
  }
  if (68505...68508).contains(scalar.value) {
    return 1
  }
  if (68521...68527).contains(scalar.value) {
    return 1
  }
  if (68608...68680).contains(scalar.value) {
    return 1
  }
  if (68736...68786).contains(scalar.value) {
    return 1
  }
  if (68800...68850).contains(scalar.value) {
    return 1
  }
  if (68858...68903).contains(scalar.value) {
    return 1
  }
  if (68912...68921).contains(scalar.value) {
    return 1
  }
  if (69216...69246).contains(scalar.value) {
    return 1
  }
  if (69248...69289).contains(scalar.value) {
    return 1
  }
  if (69291...69293).contains(scalar.value) {
    return 1
  }
  if (69296...69297).contains(scalar.value) {
    return 1
  }
  if (69373...69415).contains(scalar.value) {
    return 1
  }
  if (69424...69465).contains(scalar.value) {
    return 1
  }
  if (69488...69513).contains(scalar.value) {
    return 1
  }
  if (69552...69579).contains(scalar.value) {
    return 1
  }
  if (69600...69622).contains(scalar.value) {
    return 1
  }
  if (69632...69709).contains(scalar.value) {
    return 1
  }
  if (69714...69749).contains(scalar.value) {
    return 1
  }
  if (69759...69826).contains(scalar.value) {
    return 1
  }
  if (69837...69837).contains(scalar.value) {
    return 1
  }
  if (69840...69864).contains(scalar.value) {
    return 1
  }
  if (69872...69881).contains(scalar.value) {
    return 1
  }
  if (69888...69940).contains(scalar.value) {
    return 1
  }
  if (69942...69959).contains(scalar.value) {
    return 1
  }
  if (69968...70006).contains(scalar.value) {
    return 1
  }
  if (70016...70111).contains(scalar.value) {
    return 1
  }
  if (70113...70132).contains(scalar.value) {
    return 1
  }
  if (70144...70161).contains(scalar.value) {
    return 1
  }
  if (70163...70209).contains(scalar.value) {
    return 1
  }
  if (70272...70278).contains(scalar.value) {
    return 1
  }
  if (70280...70280).contains(scalar.value) {
    return 1
  }
  if (70282...70285).contains(scalar.value) {
    return 1
  }
  if (70287...70301).contains(scalar.value) {
    return 1
  }
  if (70303...70313).contains(scalar.value) {
    return 1
  }
  if (70320...70378).contains(scalar.value) {
    return 1
  }
  if (70384...70393).contains(scalar.value) {
    return 1
  }
  if (70400...70403).contains(scalar.value) {
    return 1
  }
  if (70405...70412).contains(scalar.value) {
    return 1
  }
  if (70415...70416).contains(scalar.value) {
    return 1
  }
  if (70419...70440).contains(scalar.value) {
    return 1
  }
  if (70442...70448).contains(scalar.value) {
    return 1
  }
  if (70450...70451).contains(scalar.value) {
    return 1
  }
  if (70453...70457).contains(scalar.value) {
    return 1
  }
  if (70459...70468).contains(scalar.value) {
    return 1
  }
  if (70471...70472).contains(scalar.value) {
    return 1
  }
  if (70475...70477).contains(scalar.value) {
    return 1
  }
  if (70480...70480).contains(scalar.value) {
    return 1
  }
  if (70487...70487).contains(scalar.value) {
    return 1
  }
  if (70493...70499).contains(scalar.value) {
    return 1
  }
  if (70502...70508).contains(scalar.value) {
    return 1
  }
  if (70512...70516).contains(scalar.value) {
    return 1
  }
  if (70656...70747).contains(scalar.value) {
    return 1
  }
  if (70749...70753).contains(scalar.value) {
    return 1
  }
  if (70784...70855).contains(scalar.value) {
    return 1
  }
  if (70864...70873).contains(scalar.value) {
    return 1
  }
  if (71040...71093).contains(scalar.value) {
    return 1
  }
  if (71096...71133).contains(scalar.value) {
    return 1
  }
  if (71168...71236).contains(scalar.value) {
    return 1
  }
  if (71248...71257).contains(scalar.value) {
    return 1
  }
  if (71264...71276).contains(scalar.value) {
    return 1
  }
  if (71296...71353).contains(scalar.value) {
    return 1
  }
  if (71360...71369).contains(scalar.value) {
    return 1
  }
  if (71424...71450).contains(scalar.value) {
    return 1
  }
  if (71453...71467).contains(scalar.value) {
    return 1
  }
  if (71472...71494).contains(scalar.value) {
    return 1
  }
  if (71680...71739).contains(scalar.value) {
    return 1
  }
  if (71840...71922).contains(scalar.value) {
    return 1
  }
  if (71935...71942).contains(scalar.value) {
    return 1
  }
  if (71945...71945).contains(scalar.value) {
    return 1
  }
  if (71948...71955).contains(scalar.value) {
    return 1
  }
  if (71957...71958).contains(scalar.value) {
    return 1
  }
  if (71960...71989).contains(scalar.value) {
    return 1
  }
  if (71991...71992).contains(scalar.value) {
    return 1
  }
  if (71995...72006).contains(scalar.value) {
    return 1
  }
  if (72016...72025).contains(scalar.value) {
    return 1
  }
  if (72096...72103).contains(scalar.value) {
    return 1
  }
  if (72106...72151).contains(scalar.value) {
    return 1
  }
  if (72154...72164).contains(scalar.value) {
    return 1
  }
  if (72192...72263).contains(scalar.value) {
    return 1
  }
  if (72272...72354).contains(scalar.value) {
    return 1
  }
  if (72368...72440).contains(scalar.value) {
    return 1
  }
  if (72448...72457).contains(scalar.value) {
    return 1
  }
  if (72704...72712).contains(scalar.value) {
    return 1
  }
  if (72714...72758).contains(scalar.value) {
    return 1
  }
  if (72760...72773).contains(scalar.value) {
    return 1
  }
  if (72784...72812).contains(scalar.value) {
    return 1
  }
  if (72816...72847).contains(scalar.value) {
    return 1
  }
  if (72850...72871).contains(scalar.value) {
    return 1
  }
  if (72873...72886).contains(scalar.value) {
    return 1
  }
  if (72960...72966).contains(scalar.value) {
    return 1
  }
  if (72968...72969).contains(scalar.value) {
    return 1
  }
  if (72971...73014).contains(scalar.value) {
    return 1
  }
  if (73018...73018).contains(scalar.value) {
    return 1
  }
  if (73020...73021).contains(scalar.value) {
    return 1
  }
  if (73023...73031).contains(scalar.value) {
    return 1
  }
  if (73040...73049).contains(scalar.value) {
    return 1
  }
  if (73056...73061).contains(scalar.value) {
    return 1
  }
  if (73063...73064).contains(scalar.value) {
    return 1
  }
  if (73066...73102).contains(scalar.value) {
    return 1
  }
  if (73104...73105).contains(scalar.value) {
    return 1
  }
  if (73107...73112).contains(scalar.value) {
    return 1
  }
  if (73120...73129).contains(scalar.value) {
    return 1
  }
  if (73440...73464).contains(scalar.value) {
    return 1
  }
  if (73472...73488).contains(scalar.value) {
    return 1
  }
  if (73490...73530).contains(scalar.value) {
    return 1
  }
  if (73534...73561).contains(scalar.value) {
    return 1
  }
  if (73648...73648).contains(scalar.value) {
    return 1
  }
  if (73664...73713).contains(scalar.value) {
    return 1
  }
  if (73727...74649).contains(scalar.value) {
    return 1
  }
  if (74752...74862).contains(scalar.value) {
    return 1
  }
  if (74864...74868).contains(scalar.value) {
    return 1
  }
  if (74880...75075).contains(scalar.value) {
    return 1
  }
  if (77712...77810).contains(scalar.value) {
    return 1
  }
  if (77824...78933).contains(scalar.value) {
    return 1
  }
  if (82944...83526).contains(scalar.value) {
    return 1
  }
  if (92160...92728).contains(scalar.value) {
    return 1
  }
  if (92736...92766).contains(scalar.value) {
    return 1
  }
  if (92768...92777).contains(scalar.value) {
    return 1
  }
  if (92782...92862).contains(scalar.value) {
    return 1
  }
  if (92864...92873).contains(scalar.value) {
    return 1
  }
  if (92880...92909).contains(scalar.value) {
    return 1
  }
  if (92912...92917).contains(scalar.value) {
    return 1
  }
  if (92928...92997).contains(scalar.value) {
    return 1
  }
  if (93008...93017).contains(scalar.value) {
    return 1
  }
  if (93019...93025).contains(scalar.value) {
    return 1
  }
  if (93027...93047).contains(scalar.value) {
    return 1
  }
  if (93053...93071).contains(scalar.value) {
    return 1
  }
  if (93760...93850).contains(scalar.value) {
    return 1
  }
  if (93952...94026).contains(scalar.value) {
    return 1
  }
  if (94031...94087).contains(scalar.value) {
    return 1
  }
  if (94095...94111).contains(scalar.value) {
    return 1
  }
  if (94176...94180).contains(scalar.value) {
    return 2
  }
  if (94192...94193).contains(scalar.value) {
    return 2
  }
  if (94208...100343).contains(scalar.value) {
    return 2
  }
  if (100352...101589).contains(scalar.value) {
    return 2
  }
  if (101632...101640).contains(scalar.value) {
    return 2
  }
  if (110576...110579).contains(scalar.value) {
    return 2
  }
  if (110581...110587).contains(scalar.value) {
    return 2
  }
  if (110589...110590).contains(scalar.value) {
    return 2
  }
  if (110592...110882).contains(scalar.value) {
    return 2
  }
  if (110898...110898).contains(scalar.value) {
    return 2
  }
  if (110928...110930).contains(scalar.value) {
    return 2
  }
  if (110933...110933).contains(scalar.value) {
    return 2
  }
  if (110948...110951).contains(scalar.value) {
    return 2
  }
  if (110960...111355).contains(scalar.value) {
    return 2
  }
  if (113664...113770).contains(scalar.value) {
    return 1
  }
  if (113776...113788).contains(scalar.value) {
    return 1
  }
  if (113792...113800).contains(scalar.value) {
    return 1
  }
  if (113808...113817).contains(scalar.value) {
    return 1
  }
  if (113820...113827).contains(scalar.value) {
    return 1
  }
  if (118528...118573).contains(scalar.value) {
    return 1
  }
  if (118576...118598).contains(scalar.value) {
    return 1
  }
  if (118608...118723).contains(scalar.value) {
    return 1
  }
  if (118784...119029).contains(scalar.value) {
    return 1
  }
  if (119040...119078).contains(scalar.value) {
    return 1
  }
  if (119081...119274).contains(scalar.value) {
    return 1
  }
  if (119296...119365).contains(scalar.value) {
    return 1
  }
  if (119488...119507).contains(scalar.value) {
    return 1
  }
  if (119520...119539).contains(scalar.value) {
    return 1
  }
  if (119552...119638).contains(scalar.value) {
    return 1
  }
  if (119648...119672).contains(scalar.value) {
    return 1
  }
  if (119808...119892).contains(scalar.value) {
    return 1
  }
  if (119894...119964).contains(scalar.value) {
    return 1
  }
  if (119966...119967).contains(scalar.value) {
    return 1
  }
  if (119970...119970).contains(scalar.value) {
    return 1
  }
  if (119973...119974).contains(scalar.value) {
    return 1
  }
  if (119977...119980).contains(scalar.value) {
    return 1
  }
  if (119982...119993).contains(scalar.value) {
    return 1
  }
  if (119995...119995).contains(scalar.value) {
    return 1
  }
  if (119997...120003).contains(scalar.value) {
    return 1
  }
  if (120005...120069).contains(scalar.value) {
    return 1
  }
  if (120071...120074).contains(scalar.value) {
    return 1
  }
  if (120077...120084).contains(scalar.value) {
    return 1
  }
  if (120086...120092).contains(scalar.value) {
    return 1
  }
  if (120094...120121).contains(scalar.value) {
    return 1
  }
  if (120123...120126).contains(scalar.value) {
    return 1
  }
  if (120128...120132).contains(scalar.value) {
    return 1
  }
  if (120134...120134).contains(scalar.value) {
    return 1
  }
  if (120138...120144).contains(scalar.value) {
    return 1
  }
  if (120146...120485).contains(scalar.value) {
    return 1
  }
  if (120488...120779).contains(scalar.value) {
    return 1
  }
  if (120782...121483).contains(scalar.value) {
    return 1
  }
  if (121499...121503).contains(scalar.value) {
    return 1
  }
  if (121505...121519).contains(scalar.value) {
    return 1
  }
  if (122624...122654).contains(scalar.value) {
    return 1
  }
  if (122661...122666).contains(scalar.value) {
    return 1
  }
  if (122880...122886).contains(scalar.value) {
    return 1
  }
  if (122888...122904).contains(scalar.value) {
    return 1
  }
  if (122907...122913).contains(scalar.value) {
    return 1
  }
  if (122915...122916).contains(scalar.value) {
    return 1
  }
  if (122918...122922).contains(scalar.value) {
    return 1
  }
  if (122928...122989).contains(scalar.value) {
    return 1
  }
  if (123023...123023).contains(scalar.value) {
    return 1
  }
  if (123136...123180).contains(scalar.value) {
    return 1
  }
  if (123184...123197).contains(scalar.value) {
    return 1
  }
  if (123200...123209).contains(scalar.value) {
    return 1
  }
  if (123214...123215).contains(scalar.value) {
    return 1
  }
  if (123536...123566).contains(scalar.value) {
    return 1
  }
  if (123584...123641).contains(scalar.value) {
    return 1
  }
  if (123647...123647).contains(scalar.value) {
    return 1
  }
  if (124112...124153).contains(scalar.value) {
    return 1
  }
  if (124896...124902).contains(scalar.value) {
    return 1
  }
  if (124904...124907).contains(scalar.value) {
    return 1
  }
  if (124909...124910).contains(scalar.value) {
    return 1
  }
  if (124912...124926).contains(scalar.value) {
    return 1
  }
  if (124928...125124).contains(scalar.value) {
    return 1
  }
  if (125127...125142).contains(scalar.value) {
    return 1
  }
  if (125184...125259).contains(scalar.value) {
    return 1
  }
  if (125264...125273).contains(scalar.value) {
    return 1
  }
  if (125278...125279).contains(scalar.value) {
    return 1
  }
  if (126065...126132).contains(scalar.value) {
    return 1
  }
  if (126209...126269).contains(scalar.value) {
    return 1
  }
  if (126464...126467).contains(scalar.value) {
    return 1
  }
  if (126469...126495).contains(scalar.value) {
    return 1
  }
  if (126497...126498).contains(scalar.value) {
    return 1
  }
  if (126500...126500).contains(scalar.value) {
    return 1
  }
  if (126503...126503).contains(scalar.value) {
    return 1
  }
  if (126505...126514).contains(scalar.value) {
    return 1
  }
  if (126516...126519).contains(scalar.value) {
    return 1
  }
  if (126521...126521).contains(scalar.value) {
    return 1
  }
  if (126523...126523).contains(scalar.value) {
    return 1
  }
  if (126530...126530).contains(scalar.value) {
    return 1
  }
  if (126535...126535).contains(scalar.value) {
    return 1
  }
  if (126537...126537).contains(scalar.value) {
    return 1
  }
  if (126539...126539).contains(scalar.value) {
    return 1
  }
  if (126541...126543).contains(scalar.value) {
    return 1
  }
  if (126545...126546).contains(scalar.value) {
    return 1
  }
  if (126548...126548).contains(scalar.value) {
    return 1
  }
  if (126551...126551).contains(scalar.value) {
    return 1
  }
  if (126553...126553).contains(scalar.value) {
    return 1
  }
  if (126555...126555).contains(scalar.value) {
    return 1
  }
  if (126557...126557).contains(scalar.value) {
    return 1
  }
  if (126559...126559).contains(scalar.value) {
    return 1
  }
  if (126561...126562).contains(scalar.value) {
    return 1
  }
  if (126564...126564).contains(scalar.value) {
    return 1
  }
  if (126567...126570).contains(scalar.value) {
    return 1
  }
  if (126572...126578).contains(scalar.value) {
    return 1
  }
  if (126580...126583).contains(scalar.value) {
    return 1
  }
  if (126585...126588).contains(scalar.value) {
    return 1
  }
  if (126590...126590).contains(scalar.value) {
    return 1
  }
  if (126592...126601).contains(scalar.value) {
    return 1
  }
  if (126603...126619).contains(scalar.value) {
    return 1
  }
  if (126625...126627).contains(scalar.value) {
    return 1
  }
  if (126629...126633).contains(scalar.value) {
    return 1
  }
  if (126635...126651).contains(scalar.value) {
    return 1
  }
  if (126704...126705).contains(scalar.value) {
    return 1
  }
  if (126976...126979).contains(scalar.value) {
    return 1
  }
  if (126980...126980).contains(scalar.value) {
    return 2
  }
  if (126981...127019).contains(scalar.value) {
    return 1
  }
  if (127024...127123).contains(scalar.value) {
    return 1
  }
  if (127136...127150).contains(scalar.value) {
    return 1
  }
  if (127153...127167).contains(scalar.value) {
    return 1
  }
  if (127169...127182).contains(scalar.value) {
    return 1
  }
  if (127183...127183).contains(scalar.value) {
    return 2
  }
  if (127185...127221).contains(scalar.value) {
    return 1
  }
  if (127232...127242).contains(scalar.value) {
    return 1
  }
  if (127243...127247).contains(scalar.value) {
    return 1
  }
  if (127248...127277).contains(scalar.value) {
    return 1
  }
  if (127278...127279).contains(scalar.value) {
    return 1
  }
  if (127280...127337).contains(scalar.value) {
    return 1
  }
  if (127338...127343).contains(scalar.value) {
    return 1
  }
  if (127344...127373).contains(scalar.value) {
    return 1
  }
  if (127374...127374).contains(scalar.value) {
    return 2
  }
  if (127375...127376).contains(scalar.value) {
    return 1
  }
  if (127377...127386).contains(scalar.value) {
    return 2
  }
  if (127387...127404).contains(scalar.value) {
    return 1
  }
  if (127405...127405).contains(scalar.value) {
    return 1
  }
  if (127462...127487).contains(scalar.value) {
    return 1
  }
  if (127488...127490).contains(scalar.value) {
    return 2
  }
  if (127504...127547).contains(scalar.value) {
    return 2
  }
  if (127552...127560).contains(scalar.value) {
    return 2
  }
  if (127568...127569).contains(scalar.value) {
    return 2
  }
  if (127584...127589).contains(scalar.value) {
    return 2
  }
  if (127744...127776).contains(scalar.value) {
    return 2
  }
  if (127777...127788).contains(scalar.value) {
    return 1
  }
  if (127789...127797).contains(scalar.value) {
    return 2
  }
  if (127798...127798).contains(scalar.value) {
    return 1
  }
  if (127799...127868).contains(scalar.value) {
    return 2
  }
  if (127869...127869).contains(scalar.value) {
    return 1
  }
  if (127870...127891).contains(scalar.value) {
    return 2
  }
  if (127892...127903).contains(scalar.value) {
    return 1
  }
  if (127904...127946).contains(scalar.value) {
    return 2
  }
  if (127947...127950).contains(scalar.value) {
    return 1
  }
  if (127951...127955).contains(scalar.value) {
    return 2
  }
  if (127956...127967).contains(scalar.value) {
    return 1
  }
  if (127968...127984).contains(scalar.value) {
    return 2
  }
  if (127985...127987).contains(scalar.value) {
    return 1
  }
  if (127988...127988).contains(scalar.value) {
    return 2
  }
  if (127989...127991).contains(scalar.value) {
    return 1
  }
  if (127992...128062).contains(scalar.value) {
    return 2
  }
  if (128063...128063).contains(scalar.value) {
    return 1
  }
  if (128064...128064).contains(scalar.value) {
    return 2
  }
  if (128065...128065).contains(scalar.value) {
    return 1
  }
  if (128066...128252).contains(scalar.value) {
    return 2
  }
  if (128253...128254).contains(scalar.value) {
    return 1
  }
  if (128255...128317).contains(scalar.value) {
    return 2
  }
  if (128318...128330).contains(scalar.value) {
    return 1
  }
  if (128331...128334).contains(scalar.value) {
    return 2
  }
  if (128335...128335).contains(scalar.value) {
    return 1
  }
  if (128336...128359).contains(scalar.value) {
    return 2
  }
  if (128360...128377).contains(scalar.value) {
    return 1
  }
  if (128378...128378).contains(scalar.value) {
    return 2
  }
  if (128379...128404).contains(scalar.value) {
    return 1
  }
  if (128405...128406).contains(scalar.value) {
    return 2
  }
  if (128407...128419).contains(scalar.value) {
    return 1
  }
  if (128420...128420).contains(scalar.value) {
    return 2
  }
  if (128421...128506).contains(scalar.value) {
    return 1
  }
  if (128507...128591).contains(scalar.value) {
    return 2
  }
  if (128592...128639).contains(scalar.value) {
    return 1
  }
  if (128640...128709).contains(scalar.value) {
    return 2
  }
  if (128710...128715).contains(scalar.value) {
    return 1
  }
  if (128716...128716).contains(scalar.value) {
    return 2
  }
  if (128717...128719).contains(scalar.value) {
    return 1
  }
  if (128720...128722).contains(scalar.value) {
    return 2
  }
  if (128723...128724).contains(scalar.value) {
    return 1
  }
  if (128725...128727).contains(scalar.value) {
    return 2
  }
  if (128732...128735).contains(scalar.value) {
    return 2
  }
  if (128736...128746).contains(scalar.value) {
    return 1
  }
  if (128747...128748).contains(scalar.value) {
    return 2
  }
  if (128752...128755).contains(scalar.value) {
    return 1
  }
  if (128756...128764).contains(scalar.value) {
    return 2
  }
  if (128768...128886).contains(scalar.value) {
    return 1
  }
  if (128891...128985).contains(scalar.value) {
    return 1
  }
  if (128992...129003).contains(scalar.value) {
    return 2
  }
  if (129008...129008).contains(scalar.value) {
    return 2
  }
  if (129024...129035).contains(scalar.value) {
    return 1
  }
  if (129040...129095).contains(scalar.value) {
    return 1
  }
  if (129104...129113).contains(scalar.value) {
    return 1
  }
  if (129120...129159).contains(scalar.value) {
    return 1
  }
  if (129168...129197).contains(scalar.value) {
    return 1
  }
  if (129200...129201).contains(scalar.value) {
    return 1
  }
  if (129280...129291).contains(scalar.value) {
    return 1
  }
  if (129292...129338).contains(scalar.value) {
    return 2
  }
  if (129339...129339).contains(scalar.value) {
    return 1
  }
  if (129340...129349).contains(scalar.value) {
    return 2
  }
  if (129350...129350).contains(scalar.value) {
    return 1
  }
  if (129351...129535).contains(scalar.value) {
    return 2
  }
  if (129536...129619).contains(scalar.value) {
    return 1
  }
  if (129632...129645).contains(scalar.value) {
    return 1
  }
  if (129648...129660).contains(scalar.value) {
    return 2
  }
  if (129664...129672).contains(scalar.value) {
    return 2
  }
  if (129680...129725).contains(scalar.value) {
    return 2
  }
  if (129727...129733).contains(scalar.value) {
    return 2
  }
  if (129742...129755).contains(scalar.value) {
    return 2
  }
  if (129760...129768).contains(scalar.value) {
    return 2
  }
  if (129776...129784).contains(scalar.value) {
    return 2
  }
  if (129792...129938).contains(scalar.value) {
    return 1
  }
  if (129940...129994).contains(scalar.value) {
    return 1
  }
  if (130032...130041).contains(scalar.value) {
    return 1
  }
  if (131072...196605).contains(scalar.value) {
    return 2
  }
  if (196608...262141).contains(scalar.value) {
    return 2
  }
  if (917505...917505).contains(scalar.value) {
    return 1
  }
  if (917536...917631).contains(scalar.value) {
    return 1
  }
  if (917760...917999).contains(scalar.value) {
    return 1
  }
  if (983040...1048573).contains(scalar.value) {
    return 1
  }
  if (1048576...1114109).contains(scalar.value) {
    return 1
  }
  return 1
}
