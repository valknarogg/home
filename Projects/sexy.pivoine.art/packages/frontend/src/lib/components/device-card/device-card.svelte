<script lang="ts">
import { cn } from "$lib/utils";
import { Slider } from "$lib/components/ui/slider";
import { Label } from "$lib/components/ui/label";
import { Card, CardContent, CardHeader } from "$lib/components/ui/card";
import type { BluetoothDevice } from "$lib/types";
import { _ } from "svelte-i18n";
import { ActuatorType } from "@sexy.pivoine.art/buttplug";

interface Props {
	device: BluetoothDevice;
	onChange: (scalarIndex: number, val: number) => void;
	onStop: () => void;
}

let { device, onChange, onStop }: Props = $props();

function getBatteryColor(level: number) {
	if (!device.info.hasBattery) {
		return "text-gray-400";
	}
	if (level > 60) return "text-green-400";
	if (level > 30) return "text-yellow-400";
	return "text-red-400";
}

function getBatteryBgColor(level: number) {
	if (!device.info.hasBattery) {
		return "bg-gray-400/20";
	}
	if (level > 60) return "bg-green-400/20";
	if (level > 30) return "bg-yellow-400/20";
	return "bg-red-400/20";
}

function getScalarAnimations() {
	const cmds: [{ ActuatorType: typeof ActuatorType }] =
		device.info.messageAttributes.ScalarCmd;
	return cmds
		.filter((_, i: number) => !!device.actuatorValues[i])
		.map(({ ActuatorType }) => `animate-${ActuatorType.toLowerCase()}`);
}

function isActive() {
	const cmds: [{ ActuatorType: typeof ActuatorType }] =
		device.info.messageAttributes.ScalarCmd;
	return cmds.some((_, i: number) => !!device.actuatorValues[i]);
}
</script>

<Card
    class="group hover:shadow-lg hover:shadow-primary/10 transition-all duration-300 border-border/50 hover:border-primary/30 bg-card/50 backdrop-blur-sm"
>
    <CardHeader class="pb-3">
        <div class="flex items-start justify-between">
            <div class="flex items-center gap-3">
                <div
                    class="p-2 rounded-lg bg-gradient-to-br from-primary/20 to-accent/20 border border-primary/30 flex shrink-0 grow-0"
                >
                    <span class={cn([...getScalarAnimations(), "icon-[ri--rocket-line] w-5 h-5 text-primary"])}></span>
                </div>
                <div>
                    <h3
                        class={`font-semibold text-card-foreground group-hover:text-primary transition-colors`}
                    >
                        {device.name}
                    </h3>
                    <!-- <p class="text-sm text-muted-foreground">
						{device.deviceType}
					</p> -->
                </div>
            </div>
            <button class={`${isActive() ? "cursor-pointer" : ""} flex items-center gap-2`} onclick={() => isActive() && onStop()}>
                <div class="relative">
                    <div
                        class="w-2 h-2 rounded-full {isActive()
                        ? 'bg-green-400'
                        : 'bg-red-400'}"
                    ></div>
                    {#if isActive()}
                        <div
                        class="absolute inset-0 w-2 h-2 rounded-full bg-green-400 animate-ping opacity-75"
                        ></div>
                    {/if}
                </div>
                <span
                class="text-xs font-medium {isActive()
                    ? 'text-green-400'
                    : 'text-red-400'}"
                >
                {isActive()
                    ? $_("device_card.active")
                    : $_("device_card.paused")}
                </span>
            </button>
        </div>
    </CardHeader>

    <CardContent class="space-y-4">
        <!-- Current Value -->
        <!-- <div
      class="flex items-center justify-between p-3 rounded-lg bg-muted/30 border border-border/30"
    >
      <span class="text-sm text-muted-foreground"
        >{$_("device_card.current_value")}</span
      >
      <span class="font-medium text-card-foreground">{device.currentValue}</span
      >
    </div> -->

        <!-- Battery Level -->
        <div class="space-y-2">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span
                        class="icon-[ri--battery-2-charge-line] w-4 h-4 {getBatteryColor(
                            device.batteryLevel,
                        )}"
                    ></span>
                    <span class="text-sm text-muted-foreground">{$_("device_card.battery")}</span>
                </div>
                {#if device.info.hasBattery}
                <span class="text-sm font-medium {getBatteryColor(device.batteryLevel)}">
                    {device.batteryLevel}%
                </span>
                {/if}
            </div>
            <div class="w-full bg-muted/50 rounded-full h-2 overflow-hidden">
                <div
                    class="h-full rounded-full transition-all duration-500 {getBatteryBgColor(
                        device.batteryLevel,
                    )} bg-gradient-to-r from-current to-current/80"
                    style="width: {device.batteryLevel}%"
                ></div>
            </div>
        </div>

        <!-- Last Seen -->
        <!-- <div
      class="flex items-center justify-between text-xs text-muted-foreground"
    >
      <span>{$_("device_card.last_seen")}</span>
      <span>{device.lastSeen.toLocaleTimeString()}</span>
    </div> -->

        <!-- Action Button -->
        {#each device.info.messageAttributes.ScalarCmd as scalarCmd}
            <div class="space-y-2">
                <Label for={`device-${device.info.index}-${scalarCmd.Index}`}
                    >{$_(
                        `device_card.actuator_types.${scalarCmd.ActuatorType.toLowerCase()}`,
                    )}</Label
                >
                <Slider
                    id={`device-${device.info.index}-${scalarCmd.Index}`}
                    type="single"
                    value={device.actuatorValues[scalarCmd.Index]}
                    onValueChange={(val) => onChange(scalarCmd.Index, val)}
                    max={scalarCmd.StepCount}
                    step={1}
                />
            </div>
        {/each}
    </CardContent>
</Card>
