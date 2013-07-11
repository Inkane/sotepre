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
      "      if (f(x) == p->v)<span style=\"color:#FF3213\">4.294.967.295 values for x</span><br>" +
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
	    "You have a supercomputer, right?",
	    "Problem: Needs to enumerate all conditions"
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
	}
    }
    
    Slide {
	id: instrumentation
	title: "Instrumentation"
	content: [
	    "needed for symbolic execution",
	    "adds instrumentation statements",
	    "program code\tinstrumented code\n//assignment \texecute symbolic(&v,“e”);\nv ← e;\t\t\tv ← e"
	]
    }

    CodeSlide {
	id: inputGeneration
	title: "Input generation"
        notes: "concolic: concrete + symbolic"
	code: p.c_code;
	property int index: 0
	
	
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
	    anchors.right: parent.right
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
	    anchors.right: parent.right
	    anchors.margins: 0.2*height
	}
    }
    
    Slide {
	title: "The symbolic part of concolic"
	textFormat: Text.RichText
	content: [
	  "same time as concrete",
	  "instrumentation statements",
          "linear constraints",
	  "falls back to concrete value if unable to solve constraint",
          "  α = ν + φ; β = ε + π",
          "  α × β = <span style='color: #FF3213'>?</span> <i>//too hard</i>", 
          "  ⇒ use concrete value for either α or β",
          "invariants"
	]
    }
    
    Slide {
       title: "Summary"
       content: ["concolic = concrete + symbolic",
                 "random input",
                 "solves constraints",
                 "  to find new paths ",
                 "  to respect invariants "
                ]
    }

    Slide {
	centeredText: "?"
	fontScale: 5
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
