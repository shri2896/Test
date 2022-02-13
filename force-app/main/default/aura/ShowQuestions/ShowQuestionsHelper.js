({	
	//Get question list
	getQuestionListHelper : function(component, event, helper) {

		var selectedLanguageId = component.get('v.selectedLanguage');
		var action = component.get('c.getQuestionList');
		action.setParams({"languageId": selectedLanguageId});

		action.setCallback(this, function(response){
			var state = response.getState();

			if(state === 'SUCCESS'){
				var qLst = response.getReturnValue();					
			
				this.setQuizTime(component, event, helper);

				component.set('v.questionList', qLst);
				component.set('v.queToShow', qLst[0]);
				
				this.setOptionValue(component, event, qLst, 0);

				component.set('v.currentQueNo', 1);
				component.find('btnPrevious').set('v.disabled', true);
				
				//Get the event using registerEvent name. 
		        var cmpEvent = component.getEvent("totalQuestion").setParams({"totalQuestion" : qLst.length}).fire();

		        if(qLst.length == 1){
		        	component.find('btnNext').set('v.disabled', true);
		        }
			}
			else{
				alert('error in fetching questions..!!! ' + response.getError());
			}
		})
		$A.enqueueAction(action);
	},

	//When user press next button set the next question
	getNextQuestionHelper : function(component, event){
		var currentQue = component.get('v.currentQueNo');
		var queLst = component.get('v.questionList');	
		//Get current question number		
		var tmp = currentQue;								
		component.set('v.queToShow', queLst[currentQue]);			
		currentQue = currentQue + 1;
		//Set current question			
		component.set('v.currentQueNo', currentQue);
		component.find('btnPrevious').set('v.disabled', false);
		
		//if current que is greater than quetion list length disable the button
		if(currentQue == queLst.length){
			component.find('btnNext').set('v.disabled', true);	
		}

		var status = this.checkQuestionExists(component, event, queLst[tmp]);

		if(!status){
			this.setOptionValue(component, event, queLst, tmp)		
		}
	},


	//Set previous question
	setPreviousQuestionHelper : function(component, event){
		var currentQue = component.get('v.currentQueNo');
		var queLst = component.get('v.questionList');			
		//Getting current question number		
		currentQue = currentQue - 1;
		component.set('v.currentQueNo', currentQue);
		component.find('btnNext').set('v.disabled', false);		

		if(currentQue == 1){			
			component.find('btnPrevious').set('v.disabled', true);
		}

		component.set('v.queToShow', queLst[currentQue-1]);
		
		var status = this.checkQuestionExists(component, event, queLst[currentQue-1]);

		if(!status){
			this.setOptionValue(component, event, queLst, (currentQue-1))
		}		
		
	},

	//Set options for the current question
	setOptionValue : function (component, event, queLst, index) {
		
		var lstOfOptions = [];			
		queLst[index].Answers__r.forEach(function(itm){			
			lstOfOptions.push({'Name': itm.Options__c, 'isChecked' : false});
		})

		component.set('v.queoptions', lstOfOptions);
	},

	//When user clicks on checkbox
	getSelectedValueHelper : function(component, event, helper){				

		var currentQue = component.get('v.queToShow');
		var selectedValue = event.getSource().get('v.value');
		var option = component.get('v.queoptions');		
		
		if(currentQue.Question_has_single_ans__c){
			var updateOptionList = [];				
			var userAnswer = component.get('v.userAnswer');		
			var status = false;

			//Get all the question whose user have already answered
			userAnswer.filter(function(itm){
				var optionLst = [];				

				//Check current question exists in this list
				if(itm.question.Question__c == currentQue.Question__c){
					var currentRecordsOption = itm.option;

					currentRecordsOption.filter(function(opt){						
						// var tmp = document.createElement("DIV");
						// tmp.innerHTML = opt.Name;
						// var removeFormattingText = tmp.textContent;

						// console.log('ques 1 : ' + JSON.stringify( selectedValue))
						// console.log('ques 2 : ' + JSON.stringify(opt.Name));
						
						//Match options value with current selected readio
						if(opt.Name == selectedValue){
							status = true;

							if(opt.isChecked){
								optionLst.push({'Name' : opt.Name, 'isChecked' : false});
							}
							else{
								optionLst.push({'Name' : opt.Name, 'isChecked' : true});
							}
						}
						else{
							optionLst.push({'Name' : opt.Name, 'isChecked' : false})
						}
					})

					component.set('v.queoptions', optionLst);
				}
				else{
					var currentQuestionsOption = itm.option;
					currentQuestionsOption.filter(function(opt){
						optionLst.push(opt);
					})						
				}

				updateOptionList.push({'question' : itm.question, 'option' : optionLst});

			})

			//if value not exists in the user answer list
			if(!status){
				var optionLst = [];

				//Iterate current options
				option.filter(function(obj){
					
					// var element = document.createElement("DIV");
					// element.innerHTML = obj.Name;
					// var formattingRemoveText = element.textContent;

					// element.innerHTML = selectedValue;
					// selectedValue = element.textContent;

					// console.log('status if : ' + JSON.stringify(obj.Name));
					// console.log('status if : ' + selectedValue);

					if(obj.Name == selectedValue){
						if(obj.isChecked){
							optionLst.push({'Name' : obj.Name, 'isChecked' : false});
						}
						else{
							optionLst.push({'Name' : obj.Name, 'isChecked' : true});							
						}						
					}
					else{
						optionLst.push({'Name' : obj.Name, 'isChecked' : false});
						//optionLst.push(obj);
					}
				})

				//Push question in the list
				updateOptionList.push({'question' : currentQue, 'option' : optionLst});
				component.set('v.queoptions', optionLst);
			}

			if(updateOptionList.length > 0){
				component.set('v.userAnswer', updateOptionList);
			}							
		}
		else{
			//for checkbox 

			var updateOptionList = [];					
			var status = false;
			var userAnswer = component.get('v.userAnswer');		
			var optionLst = [];			
			
			//currentQue.Question__c retruns the plain text which includes br, center tag name so remove all the tags from plain text.
			var element = document.createElement("DIV");
			element.innerHTML = currentQue.Question__c;
			var currentQuestion = element.textContent;

			userAnswer.filter(function(record){

				if(record.question.Question__c == currentQue.Question__c){
					var queOption = option;
					status = true;
				}
				else{
					var queOption = record.option;
				}

				updateOptionList.push({'question' : record.question, 'option' : queOption});

			})

			if(!status){				
				var optionLst = [];

				option.filter(function(item){					
					// element.innerHTML = item.Name;
					// var formattingRemoveText = element.textContent;
					
					optionLst.push({"Name" : item.Name, "isChecked" : item.isChecked});
				})							
				updateOptionList.push({'question' : currentQue, 'option' : optionLst});								
			}

			if(updateOptionList.length > 0){
				component.set('v.userAnswer', updateOptionList);
			}
		}		

	},

	//if same question exists for multile times it will remove 
	checkQuestionExists : function(component, event, currentQue){
		var existingRecords = component.get('v.userAnswer');		
		var cQues = component.get('v.queToShow');		
		var status = false;
		
		existingRecords.filter(function(record){
			if(record.question.Question__c == cQues.Question__c){
				component.set('v.queoptions', record.option);
				status = true;
			}
		})

		return status;
	},

	//When user submit the quiz
	onsubmitHelper : function(component, event){
		$A.createComponent('c:ConfirmationDialogBox', {},
			function(modalComponent, status, errorMessage) {
				if (status === "SUCCESS") {
					//Show confirmation diaglog for submit quiz
					//Appending the newly created component in div										
					var body = component.find('showConfirmationDialog' ).get("v.body");
					body.push(modalComponent);
					component.find( 'showConfirmationDialog' ).set("v.body", body);
				} 
				else if (status === "INCOMPLETE") {
					console.log('Server issue or client is offline.');
				} 
				else if (status === "ERROR") {
					console.log('error');
				}
			}
		);
	},

	//When user clicks on OK in confirmation dialog box
	getConfirmationHelper : function(component, event){
		this.filterRecords(component, event);
		component.set('v.quizResult', true);
	},

	filterRecords : function(component, event){

		var queLst = component.get('v.userAnswer');
		var lstToUpdate = [];

		for(var i = 0; i < queLst.length; i++){
			var optLst = queLst[i].option;
			var status = false;
			for(var j = 0; j < optLst.length; j++){
				if(optLst[j].isChecked){
					status = true;
				}
			}

			if(status){
				lstToUpdate.push(queLst[i]);
			}
		}

		component.set('v.userAnswer', lstToUpdate);
	},

	//Set quiz time 
	setQuizTime : function(component, event, helper){
		var getHours = 'Max Time ' + component.get('v.hour');
		getHours = getHours + '.' + component.get('v.minute');
		component.set('v.totalTime', getHours);
	
		var status = window.setInterval(function() { 
			var seconds = component.get('v.second');
			var minute = component.get('v.minute');
			var hours = component.get('v.hour');

			//When times up it will show the result
			if(hours == 0 && minute == 0 && seconds == 1){	
				window.clearInterval(status);				
				helper.getConfirmationHelper(component, event);

			}

			if(seconds == 0){
				seconds = 60;

				if(minute > 0){
					minute--;
					component.set('v.minute', minute);
				}
			}

			if(minute == 0 && hours > 0){
				hours--;
				component.set('v.hour', hours);
				component.set('v.minute', 59);

			}
			
			seconds = seconds-1;
			component.set('v.second', seconds);
		}, 1000);
		
	},

	//When user clicks on the gotoquestion button it will open a new component and show all the question there with 3 tab
	//all question
	//answered question
	//unanswered question
	allQuestionPanelHelper : function(component, event){
		$A.createComponent('c:DisplayQuestionPanel', {
				'questionList' : component.get('v.questionList'),
				'answeredQuestion' : component.get('v.userAnswer')
			},
			function(modalComponent, status, errorMessage){
				if(status === 'SUCCESS'){
					var body = component.find('questionPanel').get('v.body');
					body.push(modalComponent);
					component.find('questionPanel').set('v.body', body);
				}
				else{
					alert('error in create displayquetionmodal.. ' + errorMessage);
				}
			}
		);		
	},

	//When user clicks on any question from goto question component it will set the selected question to the current question
	setSelectedQuestionHelper : function(component, event){
		var selectedQueId = event.getParam('selectedQuestion');
		var queLst = component.get('v.questionList');
		var userAns = component.get('v.userAnswer');

		var status = false;

		//if answered question list not empty
		if(!userAns.isEmpty){
			//When selected question exists in answered question list
			status = this.checkValueExists(component, event, userAns, selectedQueId, true);
		}	

		//When selected question not inculde in the answered question list.
		if(!status){
			//pass all question list. 
			this.checkValueExists(component, event, queLst, selectedQueId, false);			
		}
		
	 },

	 checkValueExists : function(component, event, questionListToCheck, selectedQueId, isUserAns){
		var status = false;
		var index;
		for(var i = 0 ; i < questionListToCheck.length; i++){	
			//for when find selected question in the answered question list
			if(isUserAns){	
				if(questionListToCheck[i].question.Id == selectedQueId){
					//for execute ansered question list block
					status = true;
					index = i;
					break;
				}
			}
			else{
				//when selected question find in the all question list and make new wrapper same as answered question list
				if(questionListToCheck[i].Id == selectedQueId){
					index = i;

					component.set('v.currentQueNo', (index+1));

					if(index == 0){
						component.find('btnPrevious').set('v.disabled', true);
					}
					else{
						component.find('btnPrevious').set('v.disabled', false);
					}
			
					if(index == questionListToCheck.length-1){
						component.find('btnNext').set('v.disabled', true);
					}
					else{
						component.find('btnNext').set('v.disabled', false);
					}

					component.set('v.queToShow', questionListToCheck[i]);
					var queLst = component.get('v.questionList');
					this.setOptionValue(component, event, component.get('v.questionList'), index);
					
					break;
				}
			}
		}
		
		if(status){		
			//component.set('v.currentQueNo', (index+1));
			var queLst = component.get('v.questionList')[index];			
			component.set('v.queToShow', questionListToCheck[index].question);
			var opt = questionListToCheck[index].option;
			component.set('v.queoptions', opt);
			this.setCurrentQuestionNo(component, event, selectedQueId);
			return true;
		}
		else{			
			return false;
		}
	 },

	 setCurrentQuestionNo : function(component, event, recId){
		var queLst = component.get('v.questionList');
		var indx = 0;

		queLst.filter(function(obj, index){
			if(obj.Id == recId){
				indx = index;				
			}
		})
		
		component.set('v.currentQueNo', indx+1);		

		if(indx == 0){
			component.find('btnPrevious').set('v.disabled', true);
		}
		else{
			component.find('btnPrevious').set('v.disabled', false);
		}

		if(indx == queLst.length-1){
			component.find('btnNext').set('v.disabled', true);
		}
		else{
			component.find('btnNext').set('v.disabled', false);
		}

	 }

})