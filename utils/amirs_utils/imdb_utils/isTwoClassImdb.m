% -------------------------------------------------------------------------
function output = isTwoClassImdb(dataset)
% -------------------------------------------------------------------------
% Copyright (c) 2017, Amir-Hossein Karimi
% All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

  output = false;
  if strcmp(dataset, 'prostate-v2-20-patients') || ...
    strcmp(dataset, 'prostate-v3-104-patients') || ...
    strcmp(dataset, 'mnist-784-two-class-9-4') || ...
    strcmp(dataset, 'mnist-784-two-class-0-1') || ...
    strcmp(dataset, 'mnist-784-two-class-8-3') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-school-bus-remote-control') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-school-bus-rocking-chair') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-school-bus-monarch-butterfly') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-school-bus-steel-arch-bridge') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-school-bus-german-shepherd') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-monarch-butterfly-lion') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-monarch-butterfly-steel-arch-bridge') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-lion-brown-bear') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-lion-german-shepherd') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-brown-bear-german-shepherd') || ...
    strcmp(dataset, 'imagenet-tiny-two-class-remote-control-rocking-chair') || ...
    strcmp(dataset, 'stl-10-two-class-airplane-bird') || ...
    strcmp(dataset, 'stl-10-two-class-airplane-cat') || ...
    strcmp(dataset, 'svhn-two-class-9-4') || ...
    strcmp(dataset, 'cifar-two-class-deer-horse') || ...
    strcmp(dataset, 'cifar-two-class-deer-truck') || ...
    strcmp(dataset, 'cifar-no-white-two-class-deer-truck') || ...
    strcmp(dataset, 'uci-spam') || ...
    strcmp(dataset, 'uci-ion')
    output = true;
  end
