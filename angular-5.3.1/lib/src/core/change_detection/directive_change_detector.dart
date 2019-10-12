import 'dart:html';
import 'dart:js_util' as js_util;

import 'package:angular/src/core/change_detection/host.dart';
import 'package:angular/src/core/linker/app_view.dart';
import 'package:angular/src/runtime.dart';

/// Base class for directive change detectors that are generated by compiler.
///
/// A directive change detector only extends this class if it requires lifecycle
/// calls. Goal is to share code for ngOnChanges implementation and other
/// lifecycle methods.
class DirectiveChangeDetector {
  Object directive;
  AppView<Object> view;
  Element el;
  bool _hasHostChanges = false;

  /// Initializes a [directive] implementing [ComponentState].
  ///
  /// This method is only invoked when a directive implements [ComponentState]
  /// and is used to ensure that its change detection will in turn invalidate
  /// the host component.
  void initCd() {
    assert(directive is ComponentState, 'Should never be called');
    internalSetStateChanged(unsafeCast(directive), () {
      if (!_hasHostChanges) {
        _hasHostChanges = true;
        ChangeDetectionHost.scheduleViewUpdate(detectHostChanges, view, el);
      }
    });
  }

  void resetCd() {
    _hasHostChanges = false;
  }

  /// Overridable to handle host bindings.
  void detectHostChanges(AppView<Object> view, Element el) {}

  // Updates classes for non html nodes such as svg.
  void updateElemClass(Element element, String className, bool isAdd) {
    if (isAdd) {
      element.classes.add(className);
    } else {
      element.classes.remove(className);
    }
  }

  void setAttr(
      Element renderElement, String attributeName, String attributeValue) {
    if (attributeValue != null) {
      renderElement.setAttribute(attributeName, attributeValue);
    } else {
      renderElement.attributes.remove(attributeName);
    }
  }

  void createAttr(
      Element renderElement, String attributeName, String attributeValue) {
    renderElement.setAttribute(attributeName, attributeValue);
  }

  void setAttrNS(Element renderElement, String attrNS, String attributeName,
      String attributeValue) {
    if (attributeValue != null) {
      renderElement.setAttributeNS(attrNS, attributeName, attributeValue);
    } else {
      renderElement.getNamespacedAttributes(attrNS).remove(attributeName);
    }
  }

  void setProp(Element element, String name, Object value) {
    js_util.setProperty(element, name, value);
  }
}