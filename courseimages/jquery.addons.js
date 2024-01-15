// jQuery and jQuery UI add-ons. 200726
// Copyright owners are listed below.
/*******************************************************/
/*!
 * jQuery UI Touch Punch 0.2.3
 *
 * Copyright 2011–2014, Dave Furfero
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * Depends:
 *  jquery.ui.widget.js
 *  jquery.ui.mouse.js
 */
(function ($) {

  // Detect touch support
  $.support.touch = ("ontouchstart" in window || navigator.msMaxTouchPoints);

  // Ignore browsers without touch support
  if (!$.support.touch) {
    return;
  }

  var mouseProto = $.ui.mouse.prototype,
      _mouseInit = mouseProto._mouseInit,
      _mouseDestroy = mouseProto._mouseDestroy,
      touchHandled;

  /**
   * Simulate a mouse event based on a corresponding touch event
   * @param {Object} event A touch event
   * @param {String} simulatedType The corresponding mouse event
   */
  function simulateMouseEvent (event, simulatedType) {

    // Ignore multi-touch events
    if (event.originalEvent.touches.length > 1) {
      return;
    }

    event.preventDefault();

    var touch = event.originalEvent.changedTouches[0],
        simulatedEvent = document.createEvent('MouseEvents');

    // Initialize the simulated mouse event using the touch event's coordinates
    simulatedEvent.initMouseEvent(
      simulatedType,    // type
      true,             // bubbles
      true,             // cancelable
      window,           // view
      1,                // detail
      touch.screenX,    // screenX
      touch.screenY,    // screenY
      touch.clientX,    // clientX
      touch.clientY,    // clientY
      false,            // ctrlKey
      false,            // altKey
      false,            // shiftKey
      false,            // metaKey
      0,                // button
      null              // relatedTarget
    );

    // Dispatch the simulated event to the target element
    event.target.dispatchEvent(simulatedEvent);
  }

  /**
   * Handle the jQuery UI widget's touchstart events
   * @param {Object} event The widget element's touchstart event
   */
  mouseProto._touchStart = function (event) {

    var self = this;

    // Ignore the event if another widget is already being handled
    if (touchHandled || !self._mouseCapture(event.originalEvent.changedTouches[0])) {
      return;
    }

    // Set the flag to prevent other widgets from inheriting the touch event
    touchHandled = true;

    // Track movement to determine if interaction was a click
    self._touchMoved = false;

    // Simulate the mouseover event
    simulateMouseEvent(event, 'mouseover');

    // Simulate the mousemove event
    simulateMouseEvent(event, 'mousemove');

    // Simulate the mousedown event
    simulateMouseEvent(event, 'mousedown');
  };

  /**
   * Handle the jQuery UI widget's touchmove events
   * @param {Object} event The document's touchmove event
   */
  mouseProto._touchMove = function (event) {

    // Ignore event if not handled
    if (!touchHandled) {
      return;
    }

    // Interaction was not a click
    this._touchMoved = true;

    // Simulate the mousemove event
    simulateMouseEvent(event, 'mousemove');
  };

  /**
   * Handle the jQuery UI widget's touchend events
   * @param {Object} event The document's touchend event
   */
  mouseProto._touchEnd = function (event) {

    // Ignore event if not handled
    if (!touchHandled) {
      return;
    }

    // Simulate the mouseup event
    simulateMouseEvent(event, 'mouseup');

    // Simulate the mouseout event
    simulateMouseEvent(event, 'mouseout');

    // If the touch interaction did not move, it should trigger a click
    if (!this._touchMoved) {

      // Simulate the click event
      simulateMouseEvent(event, 'click');
    }

    // Unset the flag to allow other widgets to inherit the touch event
    touchHandled = false;
  };

  /**
   * A duck punch of the $.ui.mouse _mouseInit method to support touch events.
   * This method extends the widget with bound touch event handlers that
   * translate touch events to mouse events and pass them to the widget's
   * original mouse event handling methods.
   */
  mouseProto._mouseInit = function () {

    var self = this;

    // Delegate the touch handlers to the widget's element
    self.element.bind({
      touchstart: $.proxy(self, '_touchStart'),
      touchmove: $.proxy(self, '_touchMove'),
      touchend: $.proxy(self, '_touchEnd')
    });

    // Call the original $.ui.mouse init method
    _mouseInit.call(self);
  };

  /**
   * Remove the touch event handlers
   */
  mouseProto._mouseDestroy = function () {

    var self = this;

    // Delegate the touch handlers to the widget's element
    self.element.unbind({
      touchstart: $.proxy(self, '_touchStart'),
      touchmove: $.proxy(self, '_touchMove'),
      touchend: $.proxy(self, '_touchEnd')
    });

    // Call the original $.ui.mouse destroy method
    _mouseDestroy.call(self);
  };

})(jQuery);

/*******************************************************/
// jquery.event.move
//
// 1.3.6
//
// Stephen Band
//
// Triggers 'movestart', 'move' and 'moveend' events after
// mousemoves following a mousedown cross a distance threshold,
// similar to the native 'dragstart', 'drag' and 'dragend' events.
// Move events are throttled to animation frames. Move event objects
// have the properties:
//
// pageX:
// pageY:   Page coordinates of pointer.
// startX:
// startY:  Page coordinates of pointer at movestart.
// distX:
// distY:  Distance the pointer has moved since movestart.
// deltaX:
// deltaY:  Distance the finger has moved since last event.
// velocityX:
// velocityY:  Average velocity over last few events.


(function (module) {
	if (typeof define === 'function' && define.amd) {
		// AMD. Register as an anonymous module.
		define(['jquery'], module);
	} else {
		// Browser globals
		module(jQuery);
	}
})(function(jQuery, undefined){

	var // Number of pixels a pressed pointer travels before movestart
	    // event is fired.
	    threshold = 6,

	    add = jQuery.event.add,

	    remove = jQuery.event.remove,

	    // Just sugar, so we can have arguments in the same order as
	    // add and remove.
	    trigger = function(node, type, data) {
	    	jQuery.event.trigger(type, data, node);
	    },

	    // Shim for requestAnimationFrame, falling back to timer. See:
	    // see http://paulirish.com/2011/requestanimationframe-for-smart-animating/
	    requestFrame = (function(){
	    	return (
	    		window.requestAnimationFrame ||
	    		window.webkitRequestAnimationFrame ||
	    		window.mozRequestAnimationFrame ||
	    		window.oRequestAnimationFrame ||
	    		window.msRequestAnimationFrame ||
	    		function(fn, element){
	    			return window.setTimeout(function(){
	    				fn();
	    			}, 25);
	    		}
	    	);
	    })(),

	    ignoreTags = {
	    	textarea: true,
	    	input: true,
	    	select: true,
	    	button: true
	    },

	    mouseevents = {
	    	move: 'mousemove',
	    	cancel: 'mouseup dragstart',
	    	end: 'mouseup'
	    },

	    touchevents = {
	    	move: 'touchmove',
	    	cancel: 'touchend',
	    	end: 'touchend'
	    };


	// Constructors

	function Timer(fn){
		var callback = fn,
		    active = false,
		    running = false;

		function trigger(time) {
			if (active){
				callback();
				requestFrame(trigger);
				running = true;
				active = false;
			}
			else {
				running = false;
			}
		}

		this.kick = function(fn) {
			active = true;
			if (!running) { trigger(); }
		};

		this.end = function(fn) {
			var cb = callback;

			if (!fn) { return; }

			// If the timer is not running, simply call the end callback.
			if (!running) {
				fn();
			}
			// If the timer is running, and has been kicked lately, then
			// queue up the current callback and the end callback, otherwise
			// just the end callback.
			else {
				callback = active ?
					function(){ cb(); fn(); } :
					fn ;

				active = true;
			}
		};
	}


	// Functions

	function returnTrue() {
		return true;
	}

	function returnFalse() {
		return false;
	}

	function preventDefault(e) {
		e.preventDefault();
	}

	function preventIgnoreTags(e) {
		// Don't prevent interaction with form elements.
		if (ignoreTags[ e.target.tagName.toLowerCase() ]) { return; }

		e.preventDefault();
	}

	function isLeftButton(e) {
		// Ignore mousedowns on any button other than the left (or primary)
		// mouse button, or when a modifier key is pressed.
		return (e.which === 1 && !e.ctrlKey && !e.altKey);
	}

	function identifiedTouch(touchList, id) {
		var i, l;

		if (touchList.identifiedTouch) {
			return touchList.identifiedTouch(id);
		}

		// touchList.identifiedTouch() does not exist in
		// webkit yet… we must do the search ourselves...

		i = -1;
		l = touchList.length;

		while (++i < l) {
			if (touchList[i].identifier === id) {
				return touchList[i];
			}
		}
	}

	function changedTouch(e, event) {
		var touch = identifiedTouch(e.changedTouches, event.identifier);

		// This isn't the touch you're looking for.
		if (!touch) { return; }

		// Chrome Android (at least) includes touches that have not
		// changed in e.changedTouches. That's a bit annoying. Check
		// that this touch has changed.
		if (touch.pageX === event.pageX && touch.pageY === event.pageY) { return; }

		return touch;
	}


	// Handlers that decide when the first movestart is triggered

	function mousedown(e){
		var data;

		if (!isLeftButton(e)) { return; }

		data = {
			target: e.target,
			startX: e.pageX,
			startY: e.pageY,
			timeStamp: e.timeStamp
		};

		add(document, mouseevents.move, mousemove, data);
		add(document, mouseevents.cancel, mouseend, data);
	}

	function mousemove(e){
		var data = e.data;

		checkThreshold(e, data, e, removeMouse);
	}

	function mouseend(e) {
		removeMouse();
	}

	function removeMouse() {
		remove(document, mouseevents.move, mousemove);
		remove(document, mouseevents.cancel, mouseend);
	}

	function touchstart(e) {
		var touch, template;

		// Don't get in the way of interaction with form elements.
		if (ignoreTags[ e.target.tagName.toLowerCase() ]) { return; }

		touch = e.changedTouches[0];

		// iOS live updates the touch objects whereas Android gives us copies.
		// That means we can't trust the touchstart object to stay the same,
		// so we must copy the data. This object acts as a template for
		// movestart, move and moveend event objects.
		template = {
			target: touch.target,
			startX: touch.pageX,
			startY: touch.pageY,
			timeStamp: e.timeStamp,
			identifier: touch.identifier
		};

		// Use the touch identifier as a namespace, so that we can later
		// remove handlers pertaining only to this touch.
		add(document, touchevents.move + '.' + touch.identifier, touchmove, template);
		add(document, touchevents.cancel + '.' + touch.identifier, touchend, template);
	}

	function touchmove(e){
		var data = e.data,
		    touch = changedTouch(e, data);

		if (!touch) { return; }

		checkThreshold(e, data, touch, removeTouch);
	}

	function touchend(e) {
		var template = e.data,
		    touch = identifiedTouch(e.changedTouches, template.identifier);

		if (!touch) { return; }

		removeTouch(template.identifier);
	}

	function removeTouch(identifier) {
		remove(document, '.' + identifier, touchmove);
		remove(document, '.' + identifier, touchend);
	}


	// Logic for deciding when to trigger a movestart.

	function checkThreshold(e, template, touch, fn) {
		var distX = touch.pageX - template.startX,
		    distY = touch.pageY - template.startY;

		// Do nothing if the threshold has not been crossed.
		if ((distX * distX) + (distY * distY) < (threshold * threshold)) { return; }

		triggerStart(e, template, touch, distX, distY, fn);
	}

	function handled() {
		// this._handled should return false once, and after return true.
		this._handled = returnTrue;
		return false;
	}

	function flagAsHandled(e) {
		e._handled();
	}

	function triggerStart(e, template, touch, distX, distY, fn) {
		var node = template.target,
		    touches, time;

		touches = e.targetTouches;
		time = e.timeStamp - template.timeStamp;

		// Create a movestart object with some special properties that
		// are passed only to the movestart handlers.
		template.type = 'movestart';
		template.distX = distX;
		template.distY = distY;
		template.deltaX = distX;
		template.deltaY = distY;
		template.pageX = touch.pageX;
		template.pageY = touch.pageY;
		template.velocityX = distX / time;
		template.velocityY = distY / time;
		template.targetTouches = touches;
		template.finger = touches ?
			touches.length :
			1 ;

		// The _handled method is fired to tell the default movestart
		// handler that one of the move events is bound.
		template._handled = handled;

		// Pass the touchmove event so it can be prevented if or when
		// movestart is handled.
		template._preventTouchmoveDefault = function() {
			e.preventDefault();
		};

		// Trigger the movestart event.
		trigger(template.target, template);

		// Unbind handlers that tracked the touch or mouse up till now.
		fn(template.identifier);
	}


	// Handlers that control what happens following a movestart

	function activeMousemove(e) {
		var timer = e.data.timer;

		e.data.touch = e;
		e.data.timeStamp = e.timeStamp;
		timer.kick();
	}

	function activeMouseend(e) {
		var event = e.data.event,
		    timer = e.data.timer;

		removeActiveMouse();

		endEvent(event, timer, function() {
			// Unbind the click suppressor, waiting until after mouseup
			// has been handled.
			setTimeout(function(){
				remove(event.target, 'click', returnFalse);
			}, 0);
		});
	}

	function removeActiveMouse(event) {
		remove(document, mouseevents.move, activeMousemove);
		remove(document, mouseevents.end, activeMouseend);
	}

	function activeTouchmove(e) {
		var event = e.data.event,
		    timer = e.data.timer,
		    touch = changedTouch(e, event);

		if (!touch) { return; }

		// Stop the interface from gesturing
		e.preventDefault();

		event.targetTouches = e.targetTouches;
		e.data.touch = touch;
		e.data.timeStamp = e.timeStamp;
		timer.kick();
	}

	function activeTouchend(e) {
		var event = e.data.event,
		    timer = e.data.timer,
		    touch = identifiedTouch(e.changedTouches, event.identifier);

		// This isn't the touch you're looking for.
		if (!touch) { return; }

		removeActiveTouch(event);
		endEvent(event, timer);
	}

	function removeActiveTouch(event) {
		remove(document, '.' + event.identifier, activeTouchmove);
		remove(document, '.' + event.identifier, activeTouchend);
	}


	// Logic for triggering move and moveend events

	function updateEvent(event, touch, timeStamp, timer) {
		var time = timeStamp - event.timeStamp;

		event.type = 'move';
		event.distX =  touch.pageX - event.startX;
		event.distY =  touch.pageY - event.startY;
		event.deltaX = touch.pageX - event.pageX;
		event.deltaY = touch.pageY - event.pageY;

		// Average the velocity of the last few events using a decay
		// curve to even out spurious jumps in values.
		event.velocityX = 0.3 * event.velocityX + 0.7 * event.deltaX / time;
		event.velocityY = 0.3 * event.velocityY + 0.7 * event.deltaY / time;
		event.pageX =  touch.pageX;
		event.pageY =  touch.pageY;
	}

	function endEvent(event, timer, fn) {
		timer.end(function(){
			event.type = 'moveend';

			trigger(event.target, event);

			return fn && fn();
		});
	}


	// jQuery special event definition

	function setup(data, namespaces, eventHandle) {
		// Stop the node from being dragged
		//add(this, 'dragstart.move drag.move', preventDefault);

		// Prevent text selection and touch interface scrolling
		//add(this, 'mousedown.move', preventIgnoreTags);

		// Tell movestart default handler that we've handled this
		add(this, 'movestart.move', flagAsHandled);

		// Don't bind to the DOM. For speed.
		return true;
	}

	function teardown(namespaces) {
		remove(this, 'dragstart drag', preventDefault);
		remove(this, 'mousedown touchstart', preventIgnoreTags);
		remove(this, 'movestart', flagAsHandled);

		// Don't bind to the DOM. For speed.
		return true;
	}

	function addMethod(handleObj) {
		// We're not interested in preventing defaults for handlers that
		// come from internal move or moveend bindings
		if (handleObj.namespace === "move" || handleObj.namespace === "moveend") {
			return;
		}

		// Stop the node from being dragged
		add(this, 'dragstart.' + handleObj.guid + ' drag.' + handleObj.guid, preventDefault, undefined, handleObj.selector);

		// Prevent text selection and touch interface scrolling
		add(this, 'mousedown.' + handleObj.guid, preventIgnoreTags, undefined, handleObj.selector);
	}

	function removeMethod(handleObj) {
		if (handleObj.namespace === "move" || handleObj.namespace === "moveend") {
			return;
		}

		remove(this, 'dragstart.' + handleObj.guid + ' drag.' + handleObj.guid);
		remove(this, 'mousedown.' + handleObj.guid);
	}

	jQuery.event.special.movestart = {
		setup: setup,
		teardown: teardown,
		add: addMethod,
		remove: removeMethod,

		_default: function(e) {
			var event, data;

			// If no move events were bound to any ancestors of this
			// target, high tail it out of here.
			if (!e._handled()) { return; }

			function update(time) {
				updateEvent(event, data.touch, data.timeStamp);
				trigger(e.target, event);
			}

			event = {
				target: e.target,
				startX: e.startX,
				startY: e.startY,
				pageX: e.pageX,
				pageY: e.pageY,
				distX: e.distX,
				distY: e.distY,
				deltaX: e.deltaX,
				deltaY: e.deltaY,
				velocityX: e.velocityX,
				velocityY: e.velocityY,
				timeStamp: e.timeStamp,
				identifier: e.identifier,
				targetTouches: e.targetTouches,
				finger: e.finger
			};

			data = {
				event: event,
				timer: new Timer(update),
				touch: undefined,
				timeStamp: undefined
			};

			if (e.identifier === undefined) {
				// We're dealing with a mouse
				// Stop clicks from propagating during a move
				add(e.target, 'click', returnFalse);
				add(document, mouseevents.move, activeMousemove, data);
				add(document, mouseevents.end, activeMouseend, data);
			}
			else {
				// We're dealing with a touch. Stop touchmove doing
				// anything defaulty.
				e._preventTouchmoveDefault();
				add(document, touchevents.move + '.' + e.identifier, activeTouchmove, data);
				add(document, touchevents.end + '.' + e.identifier, activeTouchend, data);
			}
		}
	};

	jQuery.event.special.move = {
		setup: function() {
			// Bind a noop to movestart. Why? It's the movestart
			// setup that decides whether other move events are fired.
			add(this, 'movestart.move', jQuery.noop);
		},

		teardown: function() {
			remove(this, 'movestart.move', jQuery.noop);
		}
	};

	jQuery.event.special.moveend = {
		setup: function() {
			// Bind a noop to movestart. Why? It's the movestart
			// setup that decides whether other move events are fired.
			add(this, 'movestart.moveend', jQuery.noop);
		},

		teardown: function() {
			remove(this, 'movestart.moveend', jQuery.noop);
		}
	};

	add(document, 'mousedown.move', mousedown);
	add(document, 'touchstart.move', touchstart);

	// Make jQuery copy touch event properties over to the jQuery event
	// object, if they are not already listed. But only do the ones we
	// really need. IE7/8 do not have Array#indexOf(), but nor do they
	// have touch events, so let's assume we can ignore them.
	if (typeof Array.prototype.indexOf === 'function') {
		(function(jQuery, undefined){
			var props = ["changedTouches", "targetTouches"],
			    l = props.length;

			while (l--) {
				if (jQuery.event.props.indexOf(props[l]) === -1) {
					jQuery.event.props.push(props[l]);
				}
			}
		})(jQuery);
	};
});

/*******************************************************/

// jQuery.event.swipe
// 0.5
// Stephen Band

// Dependencies
// jQuery.event.move 1.2

// One of swipeleft, swiperight, swipeup or swipedown is triggered on
// moveend, when the move has covered a threshold ratio of the dimension
// of the target node, or has gone really fast. Threshold and velocity
// sensitivity changed with:
//
// jQuery.event.special.swipe.settings.threshold
// jQuery.event.special.swipe.settings.sensitivity

(function (module) {
	if (typeof define === 'function' && define.amd) {
		// AMD. Register as an anonymous module.
		define(['jquery'], module);
	} else {
		// Browser globals
		module(jQuery);
	}
})(function(jQuery, undefined){
	var add = jQuery.event.add,

	    remove = jQuery.event.remove,

	    // Just sugar, so we can have arguments in the same order as
	    // add and remove.
	    trigger = function(node, type, data) {
	    	jQuery.event.trigger(type, data, node);
	    },

	    settings = {
	    	// Ratio of distance over target finger must travel to be
	    	// considered a swipe.
	    	threshold: 0.4,
	    	// Faster fingers can travel shorter distances to be considered
	    	// swipes. 'sensitivity' controls how much. Bigger is shorter.
	    	sensitivity: 6
	    };

	function moveend(e) {
		var w, h, event;

		w = e.target.offsetWidth;
		h = e.target.offsetHeight;

		// Copy over some useful properties from the move event
		event = {
			distX: e.distX,
			distY: e.distY,
			velocityX: e.velocityX,
			velocityY: e.velocityY,
			finger: e.finger
		};

		// Find out which of the four directions was swiped
		if (e.distX > e.distY) {
			if (e.distX > -e.distY) {
				if (e.distX/w > settings.threshold || e.velocityX * e.distX/w * settings.sensitivity > 1) {
					event.type = 'swiperight';
					trigger(e.currentTarget, event);
				}
			}
			else {
				if (-e.distY/h > settings.threshold || e.velocityY * e.distY/w * settings.sensitivity > 1) {
					event.type = 'swipeup';
					trigger(e.currentTarget, event);
				}
			}
		}
		else {
			if (e.distX > -e.distY) {
				if (e.distY/h > settings.threshold || e.velocityY * e.distY/w * settings.sensitivity > 1) {
					event.type = 'swipedown';
					trigger(e.currentTarget, event);
				}
			}
			else {
				if (-e.distX/w > settings.threshold || e.velocityX * e.distX/w * settings.sensitivity > 1) {
					event.type = 'swipeleft';
					trigger(e.currentTarget, event);
				}
			}
		}
	}

	function getData(node) {
		var data = jQuery.data(node, 'event_swipe');

		if (!data) {
			data = { count: 0 };
			jQuery.data(node, 'event_swipe', data);
		}

		return data;
	}

	jQuery.event.special.swipe =
	jQuery.event.special.swipeleft =
	jQuery.event.special.swiperight =
	jQuery.event.special.swipeup =
	jQuery.event.special.swipedown = {
		setup: function( data, namespaces, eventHandle ) {
			var data = getData(this);

			// If another swipe event is already setup, don't setup again.
			if (data.count++ > 0) { return; }

			add(this, 'moveend', moveend);

			return true;
		},

		teardown: function() {
			var data = getData(this);

			// If another swipe event is still setup, don't teardown.
			if (--data.count > 0) { return; }

			remove(this, 'moveend', moveend);

			return true;
		},

		settings: settings
	};
});

/*

    PinchZoom.js
    Copyright (c) Manuel Stofer 2013 - today

    Author: Manuel Stofer (mst@rtp.ch)
    Version: 2.3.4

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

*/

// polyfills
if (typeof Object.assign != 'function') {
  // Must be writable: true, enumerable: false, configurable: true
  Object.defineProperty(Object, "assign", {
    value: function assign(target, varArgs) { // .length of function is 2
      if (target == null) { // TypeError if undefined or null
        throw new TypeError('Cannot convert undefined or null to object');
      }

      var to = Object(target);

      for (var index = 1; index < arguments.length; index++) {
        var nextSource = arguments[index];

        if (nextSource != null) { // Skip over if undefined or null
          for (var nextKey in nextSource) {
            // Avoid bugs when hasOwnProperty is shadowed
            if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
              to[nextKey] = nextSource[nextKey];
            }
          }
        }
      }
      return to;
    },
    writable: true,
    configurable: true
  });
}

if (typeof Array.from != 'function') {
  Array.from = function (object) {
    return [].slice.call(object);
  };
}

// utils
var buildElement = function(str) {
  // empty string as title argument required by IE and Edge
  var tmp = document.implementation.createHTMLDocument('');
  tmp.body.innerHTML = str;
  return Array.from(tmp.body.children)[0];
};

var triggerEvent = function(el, name) {
  var event = document.createEvent('HTMLEvents');
  event.initEvent(name, true, false);
  el.dispatchEvent(event);
};

var definePinchZoom = function () {

    /**
     * Pinch zoom
     * @param el
     * @param options
     * @constructor
     */
    var PinchZoom = function (el, options) {
            this.el = el;
            this.zoomFactor = 1;
            this.lastScale = 1;
            this.offset = {
                x: 0,
                y: 0
            };
            this.initialOffset = {
                x: 0,
                y: 0,
            };
            this.options = Object.assign({}, this.defaults, options);
            this.setupMarkup();
            this.bindEvents();
            this.update();

            // The image may already be loaded when PinchZoom is initialized,
            // and then the load event (which trigger update) will never fire.
            if (this.isImageLoaded(this.el)) {
              this.updateAspectRatio();
              this.setupOffsets();
            }

            this.enable();

        },
        sum = function (a, b) {
            return a + b;
        },
        isCloseTo = function (value, expected) {
            return value > expected - 0.01 && value < expected + 0.01;
        };

    PinchZoom.prototype = {

        defaults: {
            tapZoomFactor: 2,
            zoomOutFactor: 1.3,
            animationDuration: 300,
            maxZoom: 4,
            minZoom: 0.5,
            draggableUnzoomed: true,
            lockDragAxis: false,
            setOffsetsOnce: false,
            use2d: true,
            zoomStartEventName: 'pz_zoomstart',
            zoomUpdateEventName: 'pz_zoomupdate',
            zoomEndEventName: 'pz_zoomend',
            dragStartEventName: 'pz_dragstart',
            dragUpdateEventName: 'pz_dragupdate',
            dragEndEventName: 'pz_dragend',
            doubleTapEventName: 'pz_doubletap',
            verticalPadding: 0,
            horizontalPadding: 0,
            onZoomStart: null,
            onZoomEnd: null,
            onZoomUpdate: null,
            onDragStart: null,
            onDragEnd: null,
            onDragUpdate: null,
            onDoubleTap: null
        },

        /**
         * Event handler for 'dragstart'
         * @param event
         */
        handleDragStart: function (event) {
            triggerEvent(this.el, this.options.dragStartEventName);
            if(typeof this.options.onDragStart == "function"){
                this.options.onDragStart(this, event)
            }
            this.stopAnimation();
            this.lastDragPosition = false;
            this.hasInteraction = true;
            this.handleDrag(event);
        },

        /**
         * Event handler for 'drag'
         * @param event
         */
        handleDrag: function (event) {
            var touch = this.getTouches(event)[0];
            this.drag(touch, this.lastDragPosition);
            this.offset = this.sanitizeOffset(this.offset);
            this.lastDragPosition = touch;
        },

        handleDragEnd: function () {
            triggerEvent(this.el, this.options.dragEndEventName);
            if(typeof this.options.onDragEnd == "function"){
                this.options.onDragEnd(this, event)
            }
            this.end();
        },

        /**
         * Event handler for 'zoomstart'
         * @param event
         */
        handleZoomStart: function (event) {
            triggerEvent(this.el, this.options.zoomStartEventName);
            if(typeof this.options.onZoomStart == "function"){
                this.options.onZoomStart(this, event)
            }
            this.stopAnimation();
            this.lastScale = 1;
            this.nthZoom = 0;
            this.lastZoomCenter = false;
            this.hasInteraction = true;
        },

        /**
         * Event handler for 'zoom'
         * @param event
         */
        handleZoom: function (event, newScale) {
            // a relative scale factor is used
            var touchCenter = this.getTouchCenter(this.getTouches(event)),
                scale = newScale / this.lastScale;
            this.lastScale = newScale;

            // the first touch events are thrown away since they are not precise
            this.nthZoom += 1;
            if (this.nthZoom > 3) {

                this.scale(scale, touchCenter);
                this.drag(touchCenter, this.lastZoomCenter);
            }
            this.lastZoomCenter = touchCenter;
        },

        handleZoomEnd: function () {
            triggerEvent(this.el, this.options.zoomEndEventName);
            if(typeof this.options.onZoomEnd == "function"){
                this.options.onZoomEnd(this, event)
            }
            this.end();
        },

        /**
         * Event handler for 'doubletap'
         * @param event
         */
        handleDoubleTap: function (event) {
            var center = this.getTouches(event)[0],
                zoomFactor = this.zoomFactor > 1 ? 1 : this.options.tapZoomFactor,
                startZoomFactor = this.zoomFactor,
                updateProgress = (function (progress) {
                    this.scaleTo(startZoomFactor + progress * (zoomFactor - startZoomFactor), center);
                }).bind(this);

            if (this.hasInteraction) {
                return;
            }

            this.isDoubleTap = true;

            if (startZoomFactor > zoomFactor) {
                center = this.getCurrentZoomCenter();
            }

            this.animate(this.options.animationDuration, updateProgress, this.swing);
            triggerEvent(this.el, this.options.doubleTapEventName);
            if(typeof this.options.onDoubleTap == "function"){
                this.options.onDoubleTap(this, event)
            }
        },

        /**
         * Compute the initial offset
         *
         * the element should be centered in the container upon initialization
         */
        computeInitialOffset: function () {
            this.initialOffset = {
                x: -Math.abs(this.el.offsetWidth * this.getInitialZoomFactor() - this.container.offsetWidth) / 2,
                y: -Math.abs(this.el.offsetHeight * this.getInitialZoomFactor() - this.container.offsetHeight) / 2,
            };
        },

        /**
         * Reset current image offset to that of the initial offset
         */
        resetOffset: function() {
            this.offset.x = this.initialOffset.x;
            this.offset.y = this.initialOffset.y;
        },

        /**
         * Determine if image is loaded
         */
        isImageLoaded: function (el) {
            if (el.nodeName === 'IMG') {
              return el.complete && el.naturalHeight !== 0;
            } else {
              return Array.from(el.querySelectorAll('img')).every(this.isImageLoaded);
            }
        },

        setupOffsets: function() {
            if (this.options.setOffsetsOnce && this._isOffsetsSet) {
              return;
            }

            this._isOffsetsSet = true;

            this.computeInitialOffset();
            this.resetOffset();
        },

        /**
         * Max / min values for the offset
         * @param offset
         * @return {Object} the sanitized offset
         */
        sanitizeOffset: function (offset) {
            var elWidth = this.el.offsetWidth * this.getInitialZoomFactor() * this.zoomFactor;
            var elHeight = this.el.offsetHeight * this.getInitialZoomFactor() * this.zoomFactor;
            var maxX = elWidth - this.getContainerX() + this.options.horizontalPadding,
                maxY = elHeight -  this.getContainerY() + this.options.verticalPadding,
                maxOffsetX = Math.max(maxX, 0),
                maxOffsetY = Math.max(maxY, 0),
                minOffsetX = Math.min(maxX, 0) - this.options.horizontalPadding,
                minOffsetY = Math.min(maxY, 0) - this.options.verticalPadding;

            return {
                x: Math.min(Math.max(offset.x, minOffsetX), maxOffsetX),
                y: Math.min(Math.max(offset.y, minOffsetY), maxOffsetY)
            };
        },

        /**
         * Scale to a specific zoom factor (not relative)
         * @param zoomFactor
         * @param center
         */
        scaleTo: function (zoomFactor, center) {
            this.scale(zoomFactor / this.zoomFactor, center);
        },

        /**
         * Scales the element from specified center
         * @param scale
         * @param center
         */
        scale: function (scale, center) {
            scale = this.scaleZoomFactor(scale);
            this.addOffset({
                x: (scale - 1) * (center.x + this.offset.x),
                y: (scale - 1) * (center.y + this.offset.y)
            });
            triggerEvent(this.el, this.options.zoomUpdateEventName);
            if(typeof this.options.onZoomUpdate == "function"){
                this.options.onZoomUpdate(this, event)
            }
        },

        /**
         * Scales the zoom factor relative to current state
         * @param scale
         * @return the actual scale (can differ because of max min zoom factor)
         */
        scaleZoomFactor: function (scale) {
            var originalZoomFactor = this.zoomFactor;
            this.zoomFactor *= scale;
            this.zoomFactor = Math.min(this.options.maxZoom, Math.max(this.zoomFactor, this.options.minZoom));
            return this.zoomFactor / originalZoomFactor;
        },

        /**
         * Determine if the image is in a draggable state
         *
         * When the image can be dragged, the drag event is acted upon and cancelled.
         * When not draggable, the drag event bubbles through this component.
         *
         * @return {Boolean}
         */
        canDrag: function () {
            return this.options.draggableUnzoomed || !isCloseTo(this.zoomFactor, 1);
        },

        /**
         * Drags the element
         * @param center
         * @param lastCenter
         */
        drag: function (center, lastCenter) {
            if (lastCenter) {
              if(this.options.lockDragAxis) {
                // lock scroll to position that was changed the most
                if(Math.abs(center.x - lastCenter.x) > Math.abs(center.y - lastCenter.y)) {
                  this.addOffset({
                    x: -(center.x - lastCenter.x),
                    y: 0
                  });
                }
                else {
                  this.addOffset({
                    y: -(center.y - lastCenter.y),
                    x: 0
                  });
                }
              }
              else {
                this.addOffset({
                  y: -(center.y - lastCenter.y),
                  x: -(center.x - lastCenter.x)
                });
              }
              triggerEvent(this.el, this.options.dragUpdateEventName);
              if(typeof this.options.onDragUpdate == "function"){
                this.options.onDragUpdate(this, event)
            }
            }
        },

        /**
         * Calculates the touch center of multiple touches
         * @param touches
         * @return {Object}
         */
        getTouchCenter: function (touches) {
            return this.getVectorAvg(touches);
        },

        /**
         * Calculates the average of multiple vectors (x, y values)
         */
        getVectorAvg: function (vectors) {
            return {
                x: vectors.map(function (v) { return v.x; }).reduce(sum) / vectors.length,
                y: vectors.map(function (v) { return v.y; }).reduce(sum) / vectors.length
            };
        },

        /**
         * Adds an offset
         * @param offset the offset to add
         * @return return true when the offset change was accepted
         */
        addOffset: function (offset) {
            this.offset = {
                x: this.offset.x + offset.x,
                y: this.offset.y + offset.y
            };
        },

        sanitize: function () {
            if (this.zoomFactor < this.options.zoomOutFactor) {
                this.zoomOutAnimation();
            } else if (this.isInsaneOffset(this.offset)) {
                this.sanitizeOffsetAnimation();
            }
        },

        /**
         * Checks if the offset is ok with the current zoom factor
         * @param offset
         * @return {Boolean}
         */
        isInsaneOffset: function (offset) {
            var sanitizedOffset = this.sanitizeOffset(offset);
            return sanitizedOffset.x !== offset.x ||
                sanitizedOffset.y !== offset.y;
        },

        /**
         * Creates an animation moving to a sane offset
         */
        sanitizeOffsetAnimation: function () {
            var targetOffset = this.sanitizeOffset(this.offset),
                startOffset = {
                    x: this.offset.x,
                    y: this.offset.y
                },
                updateProgress = (function (progress) {
                    this.offset.x = startOffset.x + progress * (targetOffset.x - startOffset.x);
                    this.offset.y = startOffset.y + progress * (targetOffset.y - startOffset.y);
                    this.update();
                }).bind(this);

            this.animate(
                this.options.animationDuration,
                updateProgress,
                this.swing
            );
        },

        /**
         * Zooms back to the original position,
         * (no offset and zoom factor 1)
         */
        zoomOutAnimation: function () {
            if (this.zoomFactor === 1) {
                return;
            }

            var startZoomFactor = this.zoomFactor,
                zoomFactor = 1,
                center = this.getCurrentZoomCenter(),
                updateProgress = (function (progress) {
                    this.scaleTo(startZoomFactor + progress * (zoomFactor - startZoomFactor), center);
                }).bind(this);

            this.animate(
                this.options.animationDuration,
                updateProgress,
                this.swing
            );
        },

        /**
         * Updates the container aspect ratio
         *
         * Any previous container height must be cleared before re-measuring the
         * parent height, since it depends implicitly on the height of any of its children
         */
        updateAspectRatio: function () {
            this.unsetContainerY();
            this.setContainerY(this.container.parentElement.offsetHeight);
        },

        /**
         * Calculates the initial zoom factor (for the element to fit into the container)
         * @return {number} the initial zoom factor
         */
        getInitialZoomFactor: function () {
            var xZoomFactor = this.container.offsetWidth / this.el.offsetWidth;
            var yZoomFactor = this.container.offsetHeight / this.el.offsetHeight;

            return Math.min(xZoomFactor, yZoomFactor);
        },

        /**
         * Calculates the aspect ratio of the element
         * @return the aspect ratio
         */
        getAspectRatio: function () {
            return this.el.offsetWidth / this.el.offsetHeight;
        },

        /**
         * Calculates the virtual zoom center for the current offset and zoom factor
         * (used for reverse zoom)
         * @return {Object} the current zoom center
         */
        getCurrentZoomCenter: function () {
            var offsetLeft = this.offset.x - this.initialOffset.x;
            var centerX = -1 * this.offset.x - offsetLeft / (1 / this.zoomFactor - 1);

            var offsetTop = this.offset.y - this.initialOffset.y;
            var centerY = -1 * this.offset.y - offsetTop / (1 / this.zoomFactor - 1);

            return {
                x: centerX,
                y: centerY
            };
        },

        /**
         * Returns the touches of an event relative to the container offset
         * @param event
         * @return array touches
         */
        getTouches: function (event) {
            var rect = this.container.getBoundingClientRect();
            var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
            var scrollLeft = document.documentElement.scrollLeft || document.body.scrollLeft;
            var posTop = rect.top + scrollTop;
            var posLeft = rect.left + scrollLeft;

            return Array.prototype.slice.call(event.touches).map(function (touch) {
                return {
                    x: touch.pageX - posLeft,
                    y: touch.pageY - posTop,
                };
            });
        },

        /**
         * Animation loop
         * does not support simultaneous animations
         * @param duration
         * @param framefn
         * @param timefn
         * @param callback
         */
        animate: function (duration, framefn, timefn, callback) {
            var startTime = new Date().getTime(),
                renderFrame = (function () {
                    if (!this.inAnimation) { return; }
                    var frameTime = new Date().getTime() - startTime,
                        progress = frameTime / duration;
                    if (frameTime >= duration) {
                        framefn(1);
                        if (callback) {
                            callback();
                        }
                        this.update();
                        this.stopAnimation();
                        this.update();
                    } else {
                        if (timefn) {
                            progress = timefn(progress);
                        }
                        framefn(progress);
                        this.update();
                        requestAnimationFrame(renderFrame);
                    }
                }).bind(this);
            this.inAnimation = true;
            requestAnimationFrame(renderFrame);
        },

        /**
         * Stops the animation
         */
        stopAnimation: function () {
            this.inAnimation = false;
        },

        /**
         * Swing timing function for animations
         * @param p
         * @return {Number}
         */
        swing: function (p) {
            return -Math.cos(p * Math.PI) / 2  + 0.5;
        },

        getContainerX: function () {
            return this.container.offsetWidth;
        },

        getContainerY: function () {
            return this.container.offsetHeight;
        },

        setContainerY: function (y) {
            return this.container.style.height = y + 'px';
        },

        unsetContainerY: function () {
            this.container.style.height = null;
        },

        /**
         * Creates the expected html structure
         */
        setupMarkup: function () {
            this.container = buildElement('<div class="pinch-zoom-container"></div>');
            this.el.parentNode.insertBefore(this.container, this.el);
            this.container.appendChild(this.el);

            this.container.style.overflow = 'hidden';
            this.container.style.position = 'relative';

            this.el.style.webkitTransformOrigin = '0% 0%';
            this.el.style.mozTransformOrigin = '0% 0%';
            this.el.style.msTransformOrigin = '0% 0%';
            this.el.style.oTransformOrigin = '0% 0%';
            this.el.style.transformOrigin = '0% 0%';

            this.el.style.position = 'absolute';
        },

        end: function () {
            this.hasInteraction = false;
            this.sanitize();
            this.update();
        },

        /**
         * Binds all required event listeners
         */
        bindEvents: function () {
            var self = this;
            detectGestures(this.container, this);

            window.addEventListener('resize', this.update.bind(this));
            Array.from(this.el.querySelectorAll('img')).forEach(function(imgEl) {
              imgEl.addEventListener('load', self.update.bind(self));
            });

            if (this.el.nodeName === 'IMG') {
              this.el.addEventListener('load', this.update.bind(this));
            }
        },

        /**
         * Updates the css values according to the current zoom factor and offset
         */
        update: function (event) {
            if (this.updatePlaned) {
                return;
            }
            this.updatePlaned = true;

            window.setTimeout((function () {
                this.updatePlaned = false;

                if (event && event.type === 'resize') {
                    this.updateAspectRatio();
                    this.setupOffsets();
                }

                if (event && event.type === 'load') {
                  this.updateAspectRatio();
                  this.setupOffsets();
                }

                var zoomFactor = this.getInitialZoomFactor() * this.zoomFactor,
                    offsetX = -this.offset.x / zoomFactor,
                    offsetY = -this.offset.y / zoomFactor,
                    transform3d =   'scale3d('     + zoomFactor + ', '  + zoomFactor + ',1) ' +
                        'translate3d(' + offsetX    + 'px,' + offsetY    + 'px,0px)',
                    transform2d =   'scale('       + zoomFactor + ', '  + zoomFactor + ') ' +
                        'translate('   + offsetX    + 'px,' + offsetY    + 'px)',
                    removeClone = (function () {
                        if (this.clone) {
                            this.clone.parentNode.removeChild(this.clone);
                            delete this.clone;
                        }
                    }).bind(this);

                // Scale 3d and translate3d are faster (at least on ios)
                // but they also reduce the quality.
                // PinchZoom uses the 3d transformations during interactions
                // after interactions it falls back to 2d transformations
                if (!this.options.use2d || this.hasInteraction || this.inAnimation) {
                    this.is3d = true;
                    removeClone();

                    this.el.style.webkitTransform = transform3d;
                    this.el.style.mozTransform = transform2d;
                    this.el.style.msTransform = transform2d;
                    this.el.style.oTransform = transform2d;
                    this.el.style.transform = transform3d;
                } else {
                    // When changing from 3d to 2d transform webkit has some glitches.
                    // To avoid this, a copy of the 3d transformed element is displayed in the
                    // foreground while the element is converted from 3d to 2d transform
                    if (this.is3d) {
                        this.clone = this.el.cloneNode(true);
                        this.clone.style.pointerEvents = 'none';
                        this.container.appendChild(this.clone);
                        window.setTimeout(removeClone, 200);
                    }

                    this.el.style.webkitTransform = transform2d;
                    this.el.style.mozTransform = transform2d;
                    this.el.style.msTransform = transform2d;
                    this.el.style.oTransform = transform2d;
                    this.el.style.transform = transform2d;

                    this.is3d = false;
                }
            }).bind(this), 0);
        },

        /**
         * Enables event handling for gestures
         */
        enable: function() {
          this.enabled = true;
        },

        /**
         * Disables event handling for gestures
         */
        disable: function() {
          this.enabled = false;
        }
    };

    var detectGestures = function (el, target) {
        var interaction = null,
            fingers = 0,
            lastTouchStart = null,
            startTouches = null,

            setInteraction = function (newInteraction, event) {
                if (interaction !== newInteraction) {

                    if (interaction && !newInteraction) {
                        switch (interaction) {
                            case "zoom":
                                target.handleZoomEnd(event);
                                break;
                            case 'drag':
                                target.handleDragEnd(event);
                                break;
                        }
                    }

                    switch (newInteraction) {
                        case 'zoom':
                            target.handleZoomStart(event);
                            break;
                        case 'drag':
                            target.handleDragStart(event);
                            break;
                    }
                }
                interaction = newInteraction;
            },

            updateInteraction = function (event) {
                if (fingers === 2) {
                    setInteraction('zoom');
                } else if (fingers === 1 && target.canDrag()) {
                    setInteraction('drag', event);
                } else {
                    setInteraction(null, event);
                }
            },

            targetTouches = function (touches) {
                return Array.from(touches).map(function (touch) {
                    return {
                        x: touch.pageX,
                        y: touch.pageY
                    };
                });
            },

            getDistance = function (a, b) {
                var x, y;
                x = a.x - b.x;
                y = a.y - b.y;
                return Math.sqrt(x * x + y * y);
            },

            calculateScale = function (startTouches, endTouches) {
                var startDistance = getDistance(startTouches[0], startTouches[1]),
                    endDistance = getDistance(endTouches[0], endTouches[1]);
                return endDistance / startDistance;
            },

            cancelEvent = function (event) {
                event.stopPropagation();
                event.preventDefault();
            },

            detectDoubleTap = function (event) {
                var time = (new Date()).getTime();

                if (fingers > 1) {
                    lastTouchStart = null;
                }

                if (time - lastTouchStart < 300) {
                    cancelEvent(event);

                    target.handleDoubleTap(event);
                    switch (interaction) {
                        case "zoom":
                            target.handleZoomEnd(event);
                            break;
                        case 'drag':
                            target.handleDragEnd(event);
                            break;
                    }
                } else {
                    target.isDoubleTap = false;
                }

                if (fingers === 1) {
                    lastTouchStart = time;
                }
            },
            firstMove = true;

        el.addEventListener('touchstart', function (event) {
            if(target.enabled) {
                firstMove = true;
                fingers = event.touches.length;
                detectDoubleTap(event);
            }
        });

        el.addEventListener('touchmove', function (event) {
            if(target.enabled && !target.isDoubleTap) {
                if (firstMove) {
                    updateInteraction(event);
                    if (interaction) {
                        cancelEvent(event);
                    }
                    startTouches = targetTouches(event.touches);
                } else {
                    switch (interaction) {
                        case 'zoom':
                            if (startTouches.length == 2 && event.touches.length == 2) {
                                target.handleZoom(event, calculateScale(startTouches, targetTouches(event.touches)));
                            }
                            break;
                        case 'drag':
                            target.handleDrag(event);
                            break;
                    }
                    if (interaction) {
                        cancelEvent(event);
                        target.update();
                    }
                }

                firstMove = false;
            }
        });

        el.addEventListener('touchend', function (event) {
            if(target.enabled) {
                fingers = event.touches.length;
                updateInteraction(event);
            }
        });
    };

    return PinchZoom;
};

var PinchZoom = definePinchZoom();
