## 2.0.0-dev

A rewrite for ProntoGUI 2.0 (wire protocol 3). Not compatible with 1.x servers.

- Protocol 3: versioned envelope with GUI epoch; explicit primitive kinds; integer field keys
  (shared 0-34, own fields from 100); fields at their default omitted from full updates.
- Notifications (Press, Release, Change, Complete, SelectionChange, Tick, Close, Submit) replace
  event fields; the NotificationsHandled mask says which ones the server handles.
- Optional fields (set or unset; unset sent as null) for layout and other "not specified" values.
- Layout and text-style fields and typed Style enums replace the Embodiment string.
- New primitives: Button, Panel, View, Dialog, Snackbar, Tabs, Tab, StaticTable, DataTable,
  ColumnSettings, FolderList, ColorField, Component.
- Replacing one container's contents no longer drops pending updates in its siblings.
- GrpcCommClient reconnects when a server ends the stream normally, not only on errors.

## 1.0.0

- Initial version.
