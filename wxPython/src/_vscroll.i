/////////////////////////////////////////////////////////////////////////////
// Name:        _vscroll.i
// Purpose:     SWIG interface defs for wxVScrolledWindow, wxVListBox, and
//              wxHtmlListBox
//
// Author:      Robin Dunn
//
// Created:     14-Aug-2003
// RCS-ID:      $Id$
// Copyright:   (c) 2003 by Total Control Software
// Licence:     wxWindows license
/////////////////////////////////////////////////////////////////////////////

// Not a %module


//---------------------------------------------------------------------------

%{
#include <wx/tipwin.h>
%}

//---------------------------------------------------------------------------
%newgroup;


// wxVScrolledWindow

%{
#include <wx/vscroll.h>
%}


// First, the C++ version
%{
class wxPyVScrolledWindow  : public wxVScrolledWindow
{
    DECLARE_ABSTRACT_CLASS(wxPyVScrolledWindow);
public:
    wxPyVScrolledWindow() : wxVScrolledWindow() {}

    wxPyVScrolledWindow(wxWindow *parent,
                        wxWindowID id = wxID_ANY,
                        const wxPoint& pos = wxDefaultPosition,
                        const wxSize& size = wxDefaultSize,
                        long style = 0,
                        const wxString& name = wxPyPanelNameStr)
        : wxVScrolledWindow(parent, id, pos, size, style, name)
    {}

    // Overridable virtuals

    // this function must be overridden in the derived class and it should
    // return the height of the given line in pixels
    DEC_PYCALLBACK_COORD_SIZET_constpure(OnGetLineHeight);


    // this function doesn't have to be overridden but it may be useful to do
    // it if calculating the lines heights is a relatively expensive operation
    // as it gives the user code a possibility to calculate several of them at
    // once
    //
    // OnGetLinesHint() is normally called just before OnGetLineHeight() but you
    // shouldn't rely on the latter being called for all lines in the interval
    // specified here. It is also possible that OnGetLineHeight() will be
    // called for the lines outside of this interval, so this is really just a
    // hint, not a promise.
    //
    // finally note that lineMin is inclusive, while lineMax is exclusive, as
    // usual
    DEC_PYCALLBACK_VOID_SIZETSIZET_const(OnGetLinesHint);


    // when the number of lines changes, we try to estimate the total height
    // of all lines which is a rather expensive operation in terms of lines
    // access, so if the user code may estimate the average height
    // better/faster than we do, it should override this function to implement
    // its own logic
    //
    // this function should return the best guess for the total height it may
    // make
    DEC_PYCALLBACK_COORD_const(EstimateTotalHeight);


    // Also expose some other interesting protected methods


    // find the index of the line we need to show at the top of the window such
    // that the last (fully or partially) visible line is the given one
    size_t FindFirstFromBottom(size_t lineLast, bool fullyVisible = false)
    { return wxVScrolledWindow::FindFirstFromBottom(lineLast, fullyVisible); }

    // get the total height of the lines between lineMin (inclusive) and
    // lineMax (exclusive)
    wxCoord GetLinesHeight(size_t lineMin, size_t lineMax) const
    { return wxVScrolledWindow::GetLinesHeight(lineMin, lineMax); }


    PYPRIVATE;
};

IMPLEMENT_ABSTRACT_CLASS(wxPyVScrolledWindow, wxVScrolledWindow);

IMP_PYCALLBACK_COORD_SIZET_constpure(wxPyVScrolledWindow, wxVScrolledWindow, OnGetLineHeight);
IMP_PYCALLBACK_VOID_SIZETSIZET_const(wxPyVScrolledWindow, wxVScrolledWindow, OnGetLinesHint);
IMP_PYCALLBACK_COORD_const          (wxPyVScrolledWindow, wxVScrolledWindow, EstimateTotalHeight);
%}



// Now define this class for SWIG

/*
   In the name of this class, "V" may stand for "variable" because it can be
   used for scrolling lines of variable heights; "virtual" because it is not
   necessary to know the heights of all lines in advance -- only those which
   are shown on the screen need to be measured; or, even, "vertical" because
   this class only supports scrolling in one direction currently (this could
   and probably will change in the future however).

   In any case, this is a generalization of the wxScrolledWindow class which
   can be only used when all lines have the same height. It lacks some other
   wxScrolledWindow features however, notably it currently lacks support for
   horizontal scrolling; it can't scroll another window nor only a rectangle
   of the window and not its entire client area.
 */

%name(VScrolledWindow) class wxPyVScrolledWindow : public wxPanel
{
public:
    %addtofunc wxPyVScrolledWindow         "self._setOORInfo(self); self._setCallbackInfo(self, VScrolledWindow)"
    %addtofunc wxPyVScrolledWindow()       "val._setOORInfo(self)"
    

    wxPyVScrolledWindow(wxWindow *parent,
                        wxWindowID id = wxID_ANY,
                        const wxPoint& pos = wxDefaultPosition,
                        const wxSize& size = wxDefaultSize,
                        long style = 0,
                        const wxString& name = wxPyPanelNameStr);

    %name(PreVScrolledWindow)wxPyVScrolledWindow();

    void _setCallbackInfo(PyObject* self, PyObject* _class);

    bool Create(wxWindow *parent,
                wxWindowID id = wxID_ANY,
                const wxPoint& pos = wxDefaultPosition,
                const wxSize& size = wxDefaultSize,
                long style = 0,
                const wxString& name = wxPyPanelNameStr);


    // set the number of lines the window contains: the derived class must
    // provide the heights for all lines with indices up to the one given here
    // in its OnGetLineHeight()
    void SetLineCount(size_t count);

    // scroll to the specified line: it will become the first visible line in
    // the window
    //
    // return true if we scrolled the window, false if nothing was done
    bool ScrollToLine(size_t line);

    // scroll by the specified number of lines/pages
    virtual bool ScrollLines(int lines);
    virtual bool ScrollPages(int pages);

    // redraw the specified line
    void RefreshLine(size_t line);

    // redraw all lines in the specified range (inclusive)
    void RefreshLines(size_t from, size_t to);

    // return the item at the specified (in physical coordinates) position or
    // wxNOT_FOUND if none, i.e. if it is below the last item
    %name(HitTestXT) int HitTest(wxCoord x, wxCoord y) const;
    int HitTest(const wxPoint& pt) const;

    // recalculate all our parameters and redisplay all lines
    virtual void RefreshAll();


    // get the number of lines this window contains (previously set by
    // SetLineCount())
    size_t GetLineCount() const;

    // get the first currently visible line
    size_t GetFirstVisibleLine() const;

    // get the last currently visible line
    size_t GetLastVisibleLine() const;

    // is this line currently visible?
    bool IsVisible(size_t line) const;

};

//---------------------------------------------------------------------------
// wxVListBox

%{
#include <wx/vlbox.h>
DECLARE_DEF_STRING(VListBoxNameStr);
%}


// First, the C++ version
%{
class wxPyVListBox  : public wxVListBox
{
    DECLARE_ABSTRACT_CLASS(wxPyVListBox);
public:
    wxPyVListBox() : wxVListBox() {}

    wxPyVListBox(wxWindow *parent,
                 wxWindowID id = wxID_ANY,
                 const wxPoint& pos = wxDefaultPosition,
                 const wxSize& size = wxDefaultSize,
                 long style = 0,
                 const wxString& name = wxPyVListBoxNameStr)
        : wxVListBox(parent, id, pos, size, style, name)
    {}

    // Overridable virtuals

    // the derived class must implement this function to actually draw the item
    // with the given index on the provided DC
    // virtual void OnDrawItem(wxDC& dc, const wxRect& rect, size_t n) const = 0;
    DEC_PYCALLBACK__DCRECTSIZET_constpure(OnDrawItem);


    // the derived class must implement this method to return the height of the
    // specified item
    // virtual wxCoord OnMeasureItem(size_t n) const = 0;
    DEC_PYCALLBACK_COORD_SIZET_constpure(OnMeasureItem);


    // this method may be used to draw separators between the lines; note that
    // the rectangle may be modified, typically to deflate it a bit before
    // passing to OnDrawItem()
    //
    // the base class version doesn't do anything
    //    virtual void OnDrawSeparator(wxDC& dc, wxRect& rect, size_t n) const;
    DEC_PYCALLBACK__DCRECTSIZET_constpure(OnDrawSeparator);


    // this method is used to draw the items background and, maybe, a border
    // around it
    //
    // the base class version implements a reasonable default behaviour which
    // consists in drawing the selected item with the standard background
    // colour and drawing a border around the item if it is either selected or
    // current
    //     virtual void OnDrawBackground(wxDC& dc, const wxRect& rect, size_t n) const;
    DEC_PYCALLBACK__DCRECTSIZET_const(OnDrawBackground);


    PYPRIVATE;
};

IMPLEMENT_ABSTRACT_CLASS(wxPyVListBox, wxVListBox);

IMP_PYCALLBACK__DCRECTSIZET_constpure(wxPyVListBox, wxVListBox, OnDrawItem);
IMP_PYCALLBACK_COORD_SIZET_constpure (wxPyVListBox, wxVListBox, OnMeasureItem);
IMP_PYCALLBACK__DCRECTSIZET_constpure(wxPyVListBox, wxVListBox, OnDrawSeparator);
IMP_PYCALLBACK__DCRECTSIZET_const    (wxPyVListBox, wxVListBox, OnDrawBackground);

%}



// Now define this class for SWIG

/*
    This class has two main differences from a regular listbox: it can have an
    arbitrarily huge number of items because it doesn't store them itself but
    uses OnDrawItem() callback to draw them and its items can have variable
    height as determined by OnMeasureItem().

    It emits the same events as wxListBox and the same event macros may be used
    with it.
 */
%name(VListBox) class wxPyVListBox : public wxPyVScrolledWindow
{
public:
    %addtofunc wxPyVListBox         "self._setOORInfo(self);self._setCallbackInfo(self, VListBox)"
    %addtofunc wxPyVListBox()       "val._setOORInfo(self)"
    

    wxPyVListBox(wxWindow *parent,
                 wxWindowID id = wxID_ANY,
                 const wxPoint& pos = wxDefaultPosition,
                 const wxSize& size = wxDefaultSize,
                 long style = 0,
                 const wxString& name = wxPyVListBoxNameStr);

    %name(PreVListBox) wxPyVListBox();

    void _setCallbackInfo(PyObject* self, PyObject* _class);

    bool Create(wxWindow *parent,
                wxWindowID id = wxID_ANY,
                const wxPoint& pos = wxDefaultPosition,
                const wxSize& size = wxDefaultSize,
                long style = 0,
                const wxString& name = wxPyVListBoxNameStr);

    // get the number of items in the control
    size_t GetItemCount() const;

    // does this control use multiple selection?
    bool HasMultipleSelection() const;

    // get the currently selected item or wxNOT_FOUND if there is no selection
    //
    // this method is only valid for the single selection listboxes
    int GetSelection() const;

    // is this item the current one?
    bool IsCurrent(size_t item) const;

    // is this item selected?
    bool IsSelected(size_t item) const;

    // get the number of the selected items (maybe 0)
    //
    // this method is valid for both single and multi selection listboxes
    size_t GetSelectedCount() const;

    // get the first selected item, returns wxNOT_FOUND if none
    //
    // cookie is an opaque parameter which should be passed to
    // GetNextSelected() later
    //
    // this method is only valid for the multi selection listboxes
    int GetFirstSelected(unsigned long& cookie) const;

    // get next selection item, return wxNOT_FOUND if no more
    //
    // cookie must be the same parameter that was passed to GetFirstSelected()
    // before
    //
    // this method is only valid for the multi selection listboxes
    int GetNextSelected(unsigned long& cookie) const;

    // get the margins around each item
    wxPoint GetMargins() const;

    // get the background colour of selected cells
    const wxColour& GetSelectionBackground() const;


    // set the number of items to be shown in the control
    //
    // this is just a synonym for wxVScrolledWindow::SetLineCount()
    void SetItemCount(size_t count);

    // delete all items from the control
    void Clear();

    // set the selection to the specified item, if it is wxNOT_FOUND the
    // selection is unset
    //
    // this function is only valid for the single selection listboxes
    void SetSelection(int selection);

    // selects or deselects the specified item which must be valid (i.e. not
    // equal to wxNOT_FOUND)
    //
    // return true if the items selection status has changed or false
    // otherwise
    //
    // this function is only valid for the multiple selection listboxes
    bool Select(size_t item, bool select = true);

    // selects the items in the specified range whose end points may be given
    // in any order
    //
    // return true if any items selection status has changed, false otherwise
    //
    // this function is only valid for the single selection listboxes
    bool SelectRange(size_t from, size_t to);

    // toggle the selection of the specified item (must be valid)
    //
    // this function is only valid for the multiple selection listboxes
    void Toggle(size_t item);

    // select all items in the listbox
    //
    // the return code indicates if any items were affected by this operation
    // (true) or if nothing has changed (false)
    bool SelectAll();

    // unselect all items in the listbox
    //
    // the return code has the same meaning as for SelectAll()
    bool DeselectAll();

    // set the margins: horizontal margin is the distance between the window
    // border and the item contents while vertical margin is half of the
    // distance between items
    //
    // by default both margins are 0
    void SetMargins(const wxPoint& pt);
    %name(SetMarginsXY) void SetMargins(wxCoord x, wxCoord y);

    // change the background colour of the selected cells
    void SetSelectionBackground(const wxColour& col);

};


//---------------------------------------------------------------------------
// wxHtmlListBox

%{
#include <wx/htmllbox.h>
%}

// First, the C++ version
%{
class wxPyHtmlListBox  : public wxHtmlListBox
{
    DECLARE_ABSTRACT_CLASS(wxPyHtmlListBox);
public:
    wxPyHtmlListBox() : wxHtmlListBox() {}

    wxPyHtmlListBox(wxWindow *parent,
                    wxWindowID id = wxID_ANY,
                    const wxPoint& pos = wxDefaultPosition,
                    const wxSize& size = wxDefaultSize,
                    long style = 0,
                    const wxString& name = wxPyVListBoxNameStr)
        : wxHtmlListBox(parent, id, pos, size, style, name)
    {}

    // Overridable virtuals

    // this method must be implemented in the derived class and should return
    // the body (i.e. without <html>) of the HTML for the given item
    DEC_PYCALLBACK_STRING_SIZET_pure(OnGetItem);

    // this function may be overridden to decorate HTML returned by OnGetItem()
    DEC_PYCALLBACK_STRING_SIZET(OnGetItemMarkup);

// TODO:
//     // this method allows to customize the selection appearance: it may be used
//     // to specify the colour of the text which normally has the given colour
//     // colFg when it is inside the selection
//     //
//     // by default, the original colour is not used at all and all text has the
//     // same (default for this system) colour inside selection
//     virtual wxColour GetSelectedTextColour(const wxColour& colFg) const;

//     // this is the same as GetSelectedTextColour() but allows to customize the
//     // background colour -- this is even more rarely used as you can change it
//     // globally using SetSelectionBackground()
//     virtual wxColour GetSelectedTextBgColour(const wxColour& colBg) const;


    PYPRIVATE;
};


IMPLEMENT_ABSTRACT_CLASS(wxPyHtmlListBox, wxHtmlListBox)

IMP_PYCALLBACK_STRING_SIZET_pure(wxPyHtmlListBox, wxHtmlListBox, OnGetItem);
IMP_PYCALLBACK_STRING_SIZET     (wxPyHtmlListBox, wxHtmlListBox, OnGetItemMarkup);

%}



// Now define this class for SWIG


// wxHtmlListBox is a listbox whose items are wxHtmlCells
%name(HtmlListBox) class wxPyHtmlListBox : public wxPyVListBox
{
public:
    %addtofunc wxPyHtmlListBox         "self._setOORInfo(self);self._setCallbackInfo(self, HtmlListBox)"
    %addtofunc wxPyHtmlListBox()       "val._setOORInfo(self)"
    

    // normal constructor which calls Create() internally
    wxPyHtmlListBox(wxWindow *parent,
                    wxWindowID id = wxID_ANY,
                    const wxPoint& pos = wxDefaultPosition,
                    const wxSize& size = wxDefaultSize,
                    long style = 0,
                    const wxString& name = wxPyVListBoxNameStr);

    %name(PreHtmlListBox) wxPyHtmlListBox();

    void _setCallbackInfo(PyObject* self, PyObject* _class);

    bool Create(wxWindow *parent,
                wxWindowID id = wxID_ANY,
                const wxPoint& pos = wxDefaultPosition,
                const wxSize& size = wxDefaultSize,
                long style = 0,
                const wxString& name = wxPyVListBoxNameStr);


    void RefreshAll();
    void SetItemCount(size_t count);

};



//---------------------------------------------------------------------------

%init %{
    // Map renamed classes back to their common name for OOR
    wxPyPtrTypeMap_Add("wxHtmlListBox",     "wxPyHtmlListBox");
    wxPyPtrTypeMap_Add("wxVListBox",        "wxPyVListBox");
    wxPyPtrTypeMap_Add("wxVScrolledWindow", "wxPyVScrolledWindow");
%}

//---------------------------------------------------------------------------
