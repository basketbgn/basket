#include "vendorsettings.h"

VendorSettings::VendorSettings() {
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_VendorSettings", this);
}

VendorSettings::~VendorSettings() {}

void VendorSettings::onBackButton() {
    delete this;
}

void VendorSettings::onUserSettingsButton() {
    userSettings = new UserSettings;
}

void VendorSettings::onSettingsElectrometerTest() {
    settingsElectrometer = new Settings_electrometer;
}
