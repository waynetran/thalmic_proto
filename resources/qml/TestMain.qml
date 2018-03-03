import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2

Item {

    //Number of variants to run
    property int numVariant: 2

    //Keeps track of number of test variants completed.
    property int numDone: 0

    //Current variant index. 0 - FourWay, 1 - TwoWay
    property int currentVariant: 0

    //These are the targets for the Four way tests
    property var fourWayTargets : ["Send/Pulse", "Send/Text", "Settings/Do not disturb", "Settings/Sleep",
        "Calendar/Today", "Calendar/Tomorrow", "Health/Pulse", "Health/Calories"
    ]

    //These are the targets for the Two way tests
    property var twoWayTargets : ["Actions/Send/Stats/Pulse", "Actions/Send/Communication/Text",
        "Actions/Settings/Modes/Do not disturb", "Actions/Settings/Modes/Sleep",
        "Info/Calendar/View/Today", "Info/Calendar/View/Tomorrow",
        "Info/Health/Cardiac/Pulse", "Info/Health/Energy/Calories"
    ]

    property string commonInstructions: "\n\n<ol><li>Lay your wrist with the device facing up like you are looking at a watch.</li><li>Each target menu item is separated by a /, tilt your wrist in the direction of each menu item to find the target.</li><li>Press Start button.</li></ol>"
    property string fourWayTitle: "Four Way Navigation Test."
    property string fourWayInstructions : "Four way navigation allows you to choose menu items by tilting your wrist forwards, backwards and sideways." + commonInstructions
    property string twoWayTitle: "Two Way Navigation Test"
    property string twoWayInstructions : "Two way navigation allows you to choose menu items by tilting your wrist forwards and backwards." + commonInstructions

    signal finished()

    function nextVariant(){
        if(numDone >= numVariant){
            finished()
            return;
        }

        currentVariant = currentVariant == 0? 1: 0
        numDone++;
        stackLayout.currentIndex = 0;
    }

    function reset(){
        stackLayout.currentIndex = 0;
        fourWay.reset();
        twoWay.reset();
        //Keep switching the first variant being shown based on the user number to prevent order bias.
        currentVariant = userSettings.numUsers() % 2 == 0 ? 0 : 1;
        numDone = 0;
    }

    StackLayout{
        id: stackLayout
        anchors.fill: parent

        ReadySetGo{
            id: trialPrep
            title: currentVariant == 0? fourWayTitle:twoWayTitle;
            description: currentVariant == 0? fourWayInstructions : twoWayInstructions;
            onNext: {
                //set the stack to the next variant. Index 0 is the ReadySetGo page. We need to add 1 to the currentVariant
                stackLayout.currentIndex = currentVariant + 1
                tiltSensor.calibrate();
                if(currentVariant == 0){
                    fourWay.start();
                }else{
                    twoWay.start();
                }
            }
        }

        VariantTest{
            id:fourWay
            targets : fourWayTargets
            title: "Four Way Tilt Navigation Test"

            navigation: VariantNav{
                id:fourWayNav
                Layout.fillHeight: true
                Layout.fillWidth: true
                opt1:"Send"
                opt1Nav: VariantNav{
                    opt1:"Location"
                    opt2:"Pulse"
                    opt3:"Wave"
                    opt4:"Text"
                }
                opt2:"Settings"
                opt2Nav: VariantNav{
                    opt1:"Bluetooth"
                    opt2:"GPS"
                    opt3:"Do not disturb"
                    opt4:"Sleep"
                }
                opt3:"Calendar"
                opt3Nav: VariantNav{
                    opt1:"Today"
                    opt2:"Tomorrow"
                    opt3:"Add Event"
                    opt4:"Cancel Event"
                }
                opt4:"Health"
                opt4Nav: VariantNav{
                    opt1:"Pulse"
                    opt2:"O2"
                    opt3:"Calories"
                    opt4:"Steps"
                }

                onFinished: {
                    //newResult(opt);
                }
            }

            onFinished: {
                numDone++;
                currentUser["fourway_results"] = fourWay.results
                currentUser["fourway_ease_of_use"] = fourWay.easeOfUse;
                nextVariant();
            }
        }

        VariantTest{
            id:twoWay
            targets : twoWayTargets
            title: "Two Way Tilt Navigation Test"

            navigation: VariantNav{
                id:twoWayNav
                Layout.fillHeight: true
                Layout.fillWidth: true
                opt1:"Actions"
                opt1Nav: VariantNav{
                    opt1:"Send"
                    opt1Nav: VariantNav{
                        opt1:"Stats"
                        opt1Nav: VariantNav{
                            opt1:"Location"
                            opt4:"Pulse"
                        }
                        opt4:"Communication"
                        opt4Nav: VariantNav{
                            opt1:"Wave"
                            opt4:"Text"
                        }
                    }
                    opt4:"Settings"
                    opt4Nav: VariantNav{
                        opt1:"Systems"
                        opt1Nav: VariantNav{
                            opt1:"Bluetooth"
                            opt4:"GPS"
                        }
                        opt4:"Modes"
                        opt4Nav: VariantNav{
                            opt1:"Do not disturb"
                            opt4:"Sleep"
                        }
                    }
                }
                opt4:"Info"
                opt4Nav: VariantNav{
                    opt1:"Calendar"
                    opt1Nav: VariantNav{
                        opt1:"View"
                        opt1Nav: VariantNav{
                            opt1:"Today"
                            opt4:"Tomorrow"
                        }
                        opt4:"Change"
                        opt4Nav: VariantNav{
                            opt1:"Add Event"
                            opt4:"Cancel Event"
                        }
                    }
                    opt4:"Health"
                    opt4Nav: VariantNav{
                        opt1:"Cardiac"
                        opt1Nav: VariantNav{
                            opt1:"Pulse"
                            opt4:"O2"
                        }
                        opt4:"Energy"
                        opt4Nav: VariantNav{
                            opt1:"Calories"
                            opt4:"Steps"
                        }
                    }
                }
            }

            onFinished: {
                numDone++;
                currentUser["twoway_results"] = twoWay.results;
                currentUser["twoway_ease_of_use"] = twoWay.easeOfUse;
                nextVariant();
            }
        }


    }
}
