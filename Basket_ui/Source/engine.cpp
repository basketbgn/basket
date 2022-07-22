#include "engine.h"

QQmlApplicationEngine* Engine::This_engine = nullptr;

Engine::Engine(){
}

void Password::setCurrentPassword(const QString& str) {
    currentPassword = str;
}

Password* Password::pThis = nullptr;
Password::Password() {
    pThis = this;
    currentPassword = "Operator";
}

Password::~Password(){
}
const QString& Password::getCurrentPassword() {
    return currentPassword;
}
