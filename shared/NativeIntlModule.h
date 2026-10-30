#pragma once

#include <AppSpecsJSI.h>
#include <formatjs/hermes/intl.h>
#include <memory>
#include <utility>

namespace facebook::react {

class NativeIntlModule final : public NativeIntlModuleCxxSpec<NativeIntlModule> {
 public:
  explicit NativeIntlModule(std::shared_ptr<CallInvoker> jsInvoker)
      : NativeIntlModuleCxxSpec(std::move(jsInvoker)) {}

  bool install(jsi::Runtime& runtime) {
    formatjs::installIntl(runtime);
    return true;
  }
};

} // namespace facebook::react
