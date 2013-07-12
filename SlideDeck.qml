import QtQuick 2.0
import Qt.labs.presentation 1.0
import QtGraphicalEffects 1.0

Presentation {
    id: p
    property variant fromSlide: slides[currentSlide]
    property variant toSlide: slides[currentSlide]
    property bool inTransition: false;

    property int transitionTime: 500;
    property string c_code: "typedef struct cell {\n" +
            "  long v;\n" +
      "  struct cell *next;\n" +
      "} cell\n" +
      "\n" +
      "long\n" +
      "f(long v) {\n" +
      "  return 2*v + 1;\n" +
      "}\n" +
      "\n" +
      "int\n" +
      "testme(cell *p, long x)\n" +
      "  if (x > 0)\n" +
      "    if (p != NULL)\n" +
      "      if (f(x) == p->v)\n" +
      "        if (p->next == p)\n" +
      "            THIS_DOES_CRASH;\n" +
      "  return 0;\n" +
      "}\n"

    property string c_rich_code: "<style type='text/css'> .pre {white-space: pre;} </style>" +
      "<p class='pre'>typedef struct cell {<br>" +
      "  long v;<br>" +
      "  struct cell *next;<br>" +
      "} cell<br>" +
      "<br>" +
      "long</br>" +
      "f(long v) {<br>" +
      "  return 2*v + 1;<br>" +
      "}<br>" +
      "<br>" +
      "int<br>" +
      "testme(cell *p, long x)<br>" +
      "  if (x > 0)<br>" +
      "    if (p != NULL)<br>" +
      "      if (f(x) == p->v)<br>" +
      "        if (p->next == p)<br>" +
      "            THIS_DOES_CRASH;<br>" +
      "  return 0;<br>" +
      "}<br></p>"

    property string annotated_code: "<style type='text/css'> .pre {white-space: pre;} </style>" +
      "<p class='pre'>typedef struct cell {<br>" +
      "  long v;<br>" +
      "  struct cell *next;<br>" +
      "} cell<br>" +
      "<br>" +
      "long</br>" +
      "f(long v) {<br>" +
      "  return 2*v + 1;<br>" +
      "}<br>" +
      "<br>" +
      "int<br>" +
      "testme(cell *p, long x)<br>" +
      "  if (x > 0)<br>" +
      "    if (p != NULL)<br>" +
      "      if (f(x) == p->v)<span style=\"color:#FF3213\">   4.294.967.295 values for x</span><br>" +
      "        if (p->next == p) <span style=\"color:#FF3213\">Theoretically ∞ values for p->next</span><br>" +
      "            THIS_DOES_CRASH;<br>" +
      "  return 0;<br>" +
      "}<br></p>"

    width: 1280
    height: 720
    titleFontFamily: "Georgia"
    fontFamily: "Raleway"
    codeFontFamily: "Monacao"
    
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.16; color: "black" }
            GradientStop { position: 0.17; color: "seashell" }
            GradientStop { position: 0.92; color: "snow" }
            GradientStop { position: 0.93; color: "black" }
        }
    }

    //Clock { textColor: "white" } no clock
    SlideCounter { textColor: "white" }

    titleColor: "floralwhite"

    showNotes: true

    Slide {
        id: firstSlide;
	textColor: "lightslategrey"
        centeredText: "CUTE"
        fontScale: 3
        notes: "Here we go!"
        content: [""]
        Image {
            source: "images/cute.jpg"
            opacity: (parent.currentBullet < 1) ? 1 : 0
	    Behavior on opacity {NumberAnimation {duration : 400}}
            height: parent.height / 3
            fillMode: Image.PreserveAspectFit
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Slide {
	id: problemSlide;
        title: "The problem"
        content: [
            "C is hard",
            "and so is life",
        ]
        contentWidth: width / 2
        Rectangle {
	    id: textSection;
	    height: problemSlide.height / 2
        }
        Rectangle {
	    id: bug
	    height: parent.height / 2
	    anchors.top: textSection.bottom;
	    Image {
		id: klingon;
		sourceSize.height: parent.height
		source: "images/bug.jpg"
	    }
	}
	CodeSection {
	    id: codeExample;
	    text: p.c_code
	}
    }

    Slide {
	id: randTest
	title: "Random testing"
	property bool stormtrooper_visible: false
	property string example_text: p.c_rich_code
	states: [
	    State {
		name: "stormtrooper"
		when: currentBullet > 3
		PropertyChanges {
		    target: randTest
		    title: "Random testing (stormtrooper approach)"
		    stormtrooper_visible: true
		    example_text: p.annotated_code
		}
	    }
	]
	
	notes: "TODO"
	content: [
	    "generally fast",
	    "uses concrete execution",
	    "impressive number of tests",
	    "none finds the bug"
	]
	Rectangle {
	    id: randomExample
	    width: parent.width
	    height: parent.height * 0.6
	    anchors.left: stormtrooper.right
	    CodeSection {
		anchors.left: parent.left
		textFormat: Text.RichText
		text: randTest.example_text
	    }
	}
	
	Rectangle {
	    id: stormtrooper
	    anchors.top: randomExample.bottom
	    anchors.left: parent.left
	    width: parent.width / 2
	    visible: randTest.stormtrooper_visible
	    opacity: visible ? 1 : 0
	    Behavior on opacity {NumberAnimation {duration : 400}}
	    Image {
		source: "images/stormtroopers-fail.png"
	    }
	}
	
	Rectangle {
	    id: randompassing
	    anchors.left: stormtrooper.right
	    anchors.top: stormtrooper.top
	    height: parent.height * 0.4
	    visible: randTest.currentBullet >= 3
	    CodeSection {
		text: "1. p = NULL, x = 20\n" +
		      "2. p = NULL, x = 0\n" +
		      "3. p != NULL, p->v=1, p->next=NULL x = 18\n" +
		      "⋮\n" +
		      "3000. p!=NULL, p->v=2 x=1, p->next=p"
	    }
	}
    }

    Slide {
	id: symbolic
	title: "Symbolic execution (Ivory tower's darling)"
	content: [
	    "explores all branches",
	    "will find path to bug (some day)",
	    "problem: Enumerates all conditions",
	    "path explosion",
	    "You have a supercomputer, right?",
	]
	Rectangle {
	    anchors.right: parent.right
	    anchors.verticalCenter: parent.verticalCenter
	    width: parent.width/2
	    Image {
		source: "images/ivory-tower.jpg"
	        fillMode: Image.PreserveAspectFit
	        width: parent.width
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		sourceSize.width: parent.width * 2/3
	    }
	}
    }
    
    Slide {
	id: solution
	title: "A cute solution"
	textFormat: Text.RichText
	content: [
	    "Random and <span style=\"color:#FF3213\">concrete</span> <b>OR</b>
<span style=\"color:#1F404F\">symbolic</span>?",
	    "Why not both?",
	    "<span style=\"color:#FF3213\">Conc</span><span
style=\"color:#1F404F1F404F\">olic</span> execution"
	]
    }

    Slide {
	id: works
	title: "How it works"
	notes: "User has to select entry function"
	Image {
	    id: flowChart
	    anchors.horizontalCenter: parent.horizontalCenter
	    source: "images/cute_flowchart.svg"
	    sourceSize.height: 0.9 * parent.height
	}
    }
    
    Slide {
	id: instrumentation
	title: "Instrumentation"
	textFormat: Text.RichText
	content: [
	    "needed for symbolic execution",
	    "adds instrumentation statements",
	    "<table border='1' width='65%' border-style='dashed'>
	      <tr>
	        <th>program code</th>
	        <th>instrumented code<br></th>
	      </tr>
	      <tr>
	        <td>//assignment<br>v ← e;</td>
	        <td>execute_symbolic(&v, 'e')<br>v ← e;</td>
	      </tr>
	      <tr>
	        <td>//conditional<br>if (p) goto l</td>
		<td>evaluate_predicate(“p”, p);<br>if (p) goto l</td>
	      </tr>
	    </table>",
	]
	Image {
	    source: "images/instrumentation.svg"
	    sourceSize.width: 200;
	    sourceSize.height: 300;
	    anchors.right: parent.right
	    anchors.margins: 100
	}
    }

    Slide {
	id: inputGen
	title: "Input generation"
	content: [
	    "uses collected constraints",
	    "Depth First Search (DFS)",
	]
	Image {
	    id: initimg
	    source: "images/initialization.svg"
	    height: 0.9*parent.height
	    anchors.horizontalCenter: parent.horizontalCenter
	}
    }
    
    CodeSlide {
	id: inputGeneration
	title: "Input generation (Example)"
        notes: "concolic: concrete + symbolic"
	code: p.c_code;
	fontSize: 30;
	property int index: 0
	
	Rectangle {
	    id: inputSVG
	    width: 200;
	    height: 300;
	    Image {
		source: "images/input.svg"
		anchors.left: parent.left
		sourceSize.width: 200;
		sourceSize.height: 300;
	    }
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.margins: 0.2*height
	}
	
	InfoBlock {
            text: [
              [""],
              [
                "p = NULL", "x = 236"
	      ],
	      [
	        "p = l3", "p->v = 634",
	        "p->next = NULL", "x = 236"
	      ],
	      [
	        "p = l3", "p->v = 3",
	        "p->next = NULL", "x = 1"
	      ],
	      [
	        "p = l3", "p->v = 3",
	        "p->next = p", "x = 1",
	      ]
	    ]
	    id: values
	    title: "Values"
	    anchors.top: parent.top
	    anchors.right: inputSVG.left
	    anchors.margins: 0.2*height
	}
	
	InfoBlock {
	    id: constraints
	    title: "Constraints"
	    text: [
	      [""],
	      ["x > 0", "p == NULL"],
              ["x > 0", "p != NULL"],
	      ["x > 0", "p != NULL", "2*x != p->v"],
              ["x > 0", "p != NULL", "2*x == p->v"],
    	      [
    	        "x>0", "p != NULL", 
	        "2*x = p->v", "p->next != p"
    	      ],
    	      [
    	        "x>0", "p != NULL", 
	        "2*x = p->v", "p->next == p"
    	      ]
	    ]
	
	    anchors.top: values.bottom
	    anchors.right: inputSVG.left
	    anchors.margins: 0.2*height
	}
    }
    
    Slide {
	title: "Concolic execution"
	textFormat: Text.RichText
	content: [
	  "symbolic and concrete at same time",
	  "approximates",
          "only linear constraints",
	  "falls back to concrete value<br>if unable to solve constraint",
          "  α = ν + φ; β = ε + π",
          "  α × β = <span style='color: #FF3213'>?</span> <i>//too hard</i>", 
          "  ⇒ use concrete value for either α or β",
          "optimized symbolic execution (3 optimizations)"
	]
	Rectangle {
	    id: concolic
	    anchors.verticalCenter: parent.verticalCenter;
	    anchors.right: parent.right
	    anchors.rightMargin: 100;
	    Image {
		source: "images/concolic.svg"
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		sourceSize.width: 200;
		sourceSize.height: 300;
	    }
	}
    }
    
    Slide {
	title: "OPT1: Fast Unsatisfiability Check"
	content: [
	    "purely syntactic",
	    "skips semantic check if last constraint is negation of previous ones",
	    "Example:",
	    "  previous constraints: x>4, y≠3, p=NULL",
	    "  new constraint: y=3 ⇒ skips check",
	    "  new constraint: x<3 ⇒ does not skip",
	    "60–95% fewer semantic checks"
	]
    }
    
    Slide {
	title: "OPT2: Common sub–constraints elimination"
	content: [
	    "checks arithmetic subconstraints",
	    "Example:",
	    "  original constraints: x>4, x>10, x>15, y<12, y<1",
	    "  after OPT2: x>15, y<1",
	    "OPT2&3 together reduce number of subconstraints by 64–90%"
	]
    }
    
    Slide {
	title: "OPT3: Incremental solving"
	content: [
	    "exploits dependencies between subconstraints",
	    "DFS ⇒ path constraint of consecutive runs differ only in few predicates"
	]
    }
    
    Slide {
	title: "Evaluation: CUTE"
	content: [
	    "authors evaluated CUTE on data structures:",
	    "  found memory leak in CUTE's code",
	    "  found 2 bugs in SGLIB",
	    "high branch coverage 70%–100%",
	    "Are data structures a valid base for evaluation?"
	]
    }
    
    Slide {
	title: "Evaluation: Concolic Testing"
	content: [
	    "A Case Study of Concolic Testing Tools and Their Limitations:",
	    "  Xiao Qu + Brian Robinson (2011)",
	    "  evaluated several concolic tools",
	    "  pointer arithmetic and library function calls are limiting",
	    "  average branch coverage: 60% (CREST & KLEE)",
	    "  high setup time"
	]
    }
    
    Slide {
       title: "Summary + Outlook"
       Image {
	   anchors.left: parent.horizontalCenter
	   anchors.verticalCenter: parent.verticalCenter
	   source: "images/cute_flowchart.svg"
	   height: parent.height * 0.9
       }
       contentWidth: width/2
       content: [
	   "concolic: best of random testing + symbolic execution",
	   "  effective for dynamic data structures",
	   "  not a golden hammer",
	   "  optimizing symbolic execution helps",
	   "future work:",
	   "  concurrent programs",
	   "  alternative to DSF"
	]
    }

    SequentialAnimation {
        id: forwardTransition
        PropertyAction { target: p; property: "inTransition"; value: true }
        PropertyAction { target: toSlide; property: "visible"; value: true }
        ParallelAnimation {
            NumberAnimation { target: fromSlide; property: "opacity"; from: 1; to: 0; duration: p.transitionTime; easing.type: Easing.Linear}
        }
        PropertyAction { target: fromSlide; property: "visible"; value: false }
        PropertyAction { target: fromSlide; property: "opacity"; value: 1 }
        PropertyAction { target: p; property: "inTransition"; value: false }
    }
    SequentialAnimation {
        id: backwardTransition
        running: false
        PropertyAction { target: p; property: "inTransition"; value: true }
        PropertyAction { target: toSlide; property: "visible"; value: true }
        ParallelAnimation {
            NumberAnimation { target: fromSlide; property: "opacity"; from: 1; to: 0; duration: p.transitionTime; easing.type: Easing.Linear}
        }
        PropertyAction { target: fromSlide; property: "visible"; value: false }
        PropertyAction { target: fromSlide; property: "opacity"; value: 1 }
        PropertyAction { target: p; property: "inTransition"; value: false }
    }

    function noswitchSlides(from, to, forward)
    {
        if (p.inTransition)
            return false

        p.fromSlide = from
        p.toSlide = to

        if (forward)
            forwardTransition.running = true
        else
            backwardTransition.running = true

        return true
    }

}
